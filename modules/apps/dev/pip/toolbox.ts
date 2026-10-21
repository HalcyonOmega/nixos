import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";
import { getSettingsListTheme } from "@oh-my-pi/pi-coding-agent";
import { Container, type SettingItem, SettingsList, Text } from "@oh-my-pi/pi-tui";

const TOOLBOX_NAME = "toolbox";
const CORE_TOOLS = ["read", "bash", "edit", "write", "grep", "glob", TOOLBOX_NAME] as const;
const CORE_TOOL_SET = new Set<string>(CORE_TOOLS);
// Active by default when registered (ask needs an interactive UI), but not required or locked.
const DEFAULT_TOOLS = [...CORE_TOOLS, "ask"] as const;
const STATE_TYPE = "pip-tool-selection";

interface ToolSelectionState {
	enabledTools: string[];
}

export default function pipToolbox(pi: ExtensionAPI) {
	const z = pi.zod;
	let enabledTools = new Set<string>(CORE_TOOLS);
	let applyQueue = Promise.resolve();

	function availableTools() {
		return pi.getAllTools().slice().sort((a, b) => a.name.localeCompare(b.name));
	}

	function availableNames(): string[] {
		return availableTools().map(tool => tool.name);
	}

	function normalizeSelection(names: Iterable<string>): { selected: string[]; missing: string[] } {
		const available = new Set(availableNames());
		const missing = [...CORE_TOOLS].filter(name => !available.has(name));
		const selected = new Set<string>();
		for (const name of CORE_TOOLS) {
			if (available.has(name)) selected.add(name);
		}
		for (const name of names) {
			if (available.has(name)) selected.add(name);
		}
		return { selected: [...selected], missing };
	}

	function persistSelection() {
		pi.appendEntry<ToolSelectionState>(STATE_TYPE, {
			enabledTools: [...enabledTools],
		});
	}

	async function applySelection(names: Iterable<string>, persist: boolean): Promise<string[]> {
		const normalized = normalizeSelection(names);
		if (normalized.missing.length > 0) {
			throw new Error(`Pip core tools are unavailable: ${normalized.missing.join(", ")}`);
		}
		enabledTools = new Set(normalized.selected);
		await pi.setActiveTools(normalized.selected);
		if (persist) persistSelection();
		return normalized.selected;
	}

	function enqueueSelection(names: Iterable<string>, persist: boolean) {
		const snapshot = [...names];
		applyQueue = applyQueue.then(() => applySelection(snapshot, persist)).then(
			() => undefined,
			error => {
				console.error(`[pip toolbox] ${error instanceof Error ? error.message : String(error)}`);
			},
		);
	}

	function savedSelection(ctx: ExtensionContext): string[] | undefined {
		const branch = ctx.sessionManager.getBranch();
		for (let index = branch.length - 1; index >= 0; index -= 1) {
			const entry = branch[index];
			if (entry.type !== "custom" || (entry as { customType?: string }).customType !== STATE_TYPE) continue;
			const data = (entry as { data?: ToolSelectionState }).data;
			if (Array.isArray(data?.enabledTools)) return data.enabledTools;
		}
		return undefined;
	}

	async function restoreSelection(ctx: ExtensionContext) {
		await applySelection(savedSelection(ctx) ?? DEFAULT_TOOLS, false);
	}

	function statusText(selected: Iterable<string>): string {
		const enabled = new Set(selected);
		const tools = availableTools();
		const active = tools.filter(tool => enabled.has(tool.name)).map(tool => tool.name);
		const inactive = tools.filter(tool => !enabled.has(tool.name)).map(tool => tool.name);
		return [`Active: ${active.join(", ") || "none"}`, `Available but inactive: ${inactive.join(", ") || "none"}`].join(
			"\n",
		);
	}

	pi.registerTool({
		name: TOOLBOX_NAME,
		label: "Toolbox",
		description:
			"Manage Pip's tool surface. Use status to inspect tools; enable only capabilities needed for the task; disable them afterward or reset to the lean core.",
		parameters: z.object({
			action: z.enum(["status", "enable", "disable", "set", "reset"]),
			tools: z.array(z.string()).optional(),
		}),
		loadMode: "essential",
		approval: "read",
		strict: true,
		async execute(_toolCallId, params) {
			const requested = params.tools ?? [];
			const available = new Set(availableNames());
			const unknown = requested.filter(name => !available.has(name));
			if (unknown.length > 0) {
				return {
					content: [
						{
							type: "text" as const,
							text: `Unknown tools: ${unknown.join(", ")}\n\n${statusText(pi.getActiveTools())}`,
						},
					],
					details: { action: params.action, unknown, active: pi.getActiveTools() },
					isError: true,
				};
			}

			if (params.action === "status") {
				return {
					content: [{ type: "text" as const, text: statusText(pi.getActiveTools()) }],
					details: { action: params.action, active: pi.getActiveTools(), available: availableNames() },
				};
			}

			if ((params.action === "enable" || params.action === "disable" || params.action === "set") && requested.length === 0) {
				return {
					content: [{ type: "text" as const, text: `${params.action} requires at least one tool name.` }],
					details: { action: params.action, active: pi.getActiveTools() },
					isError: true,
				};
			}

			const current = new Set(pi.getActiveTools());
			if (params.action === "enable") {
				for (const name of requested) current.add(name);
			} else if (params.action === "disable") {
				for (const name of requested) {
					if (!CORE_TOOL_SET.has(name)) current.delete(name);
				}
			} else if (params.action === "set") {
				current.clear();
				for (const name of requested) current.add(name);
			} else if (params.action === "reset") {
				current.clear();
				for (const name of DEFAULT_TOOLS) current.add(name);
			}

			const selected = await applySelection(current, true);
			return {
				content: [{ type: "text" as const, text: statusText(selected) }],
				details: { action: params.action, active: selected, available: availableNames() },
			};
		},
	});

	pi.registerCommand("pip-tools", {
		description: "Enable or disable optional Pip tools",
		handler: async (_args, ctx) => {
			enabledTools = new Set(pi.getActiveTools());
			const optionalTools = availableTools().filter(tool => !CORE_TOOL_SET.has(tool.name));

			await ctx.ui.custom((tui, theme, _keybindings, done) => {
				const items: SettingItem[] = optionalTools.map(tool => ({
					id: tool.name,
					label: tool.name,
					description: tool.description.split("\n").find(line => line.trim().length > 0),
					currentValue: enabledTools.has(tool.name) ? "enabled" : "disabled",
					values: ["enabled", "disabled"],
				}));

				const container = new Container();
				container.addChild(new Text(theme.fg("accent", theme.bold("Pip Tool Configuration")), 1, 0));
				container.addChild(new Text(theme.fg("dim", `Core always on: ${CORE_TOOLS.join(", ")}`), 1, 0));
				container.addChild(new Text("", 0, 0));

				const settingsList = new SettingsList(
					items,
					Math.min(items.length + 2, 18),
					getSettingsListTheme(),
					(id, newValue) => {
						if (newValue === "enabled") enabledTools.add(id);
						else enabledTools.delete(id);
						enqueueSelection(enabledTools, true);
					},
					() => done(undefined),
				);
				container.addChild(settingsList);

				return {
					render(width: number): readonly string[] {
						return container.render(width);
					},
					invalidate() {
						container.invalidate();
					},
					handleInput(data: string) {
						settingsList.handleInput?.(data);
						tui.requestRender();
					},
				};
			});
		},
	});

	pi.registerCommand("tools-core", {
		description: "Reset Pip to its lean core tools",
		handler: async (_args, ctx) => {
			const selected = await applySelection(DEFAULT_TOOLS, true);
			ctx.ui.notify(`Pip tools reset: ${selected.join(", ")}`, "info");
		},
	});

	pi.on("session_start", async (_event, ctx) => {
		await restoreSelection(ctx);
	});
	pi.on("session_tree", async (_event, ctx) => {
		await restoreSelection(ctx);
	});
	pi.on("session_branch", async (_event, ctx) => {
		await restoreSelection(ctx);
	});
}
