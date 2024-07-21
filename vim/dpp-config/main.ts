// TODO: WIP!!

import {
  BaseConfig,
  ConfigArguments,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.3.0/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.3.0/deps.ts";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

export class Config extends BaseConfig {
  //override async config(args: {
  //  denops: Denops;
  //  contextBuilder: ContextBuilder;
  //  basePath: string;
  //  dpp: Dpp;
  //}): Promise<{
  override async config(
    { denops, dpp, basePath, contextBuilder }: ConfigArguments,
  ) {
    //override async config(args): Promise<{
    //  plugins: Plugin[];
    //  stateLines: string[];
    //}> {
    // throw new Error("Method not implemented.");
    console.log({ basePath });
    //contextBuilder.setGlobal({
    //  protocols: ["git"],
    //});

    const [context, options] = await contextBuilder.get(denops);

    // Merge toml results
    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
    //for (const toml of tomls) {
    //  for (const plugin of toml.plugins) {
    //    recordPlugins[plugin.name] = plugin;
    //  }
    //
    //  if (toml.ftplugins) {
    //    for (const filetype of Object.keys(toml.ftplugins)) {
    //      if (ftplugins[filetype]) {
    //        ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
    //      } else {
    //        ftplugins[filetype] = toml.ftplugins[filetype];
    //      }
    //    }
    //  }
    //
    //  if (toml.hooks_file) {
    //    hooksFiles.push(toml.hooks_file);
    //  }
    //}

    //const localPlugins = await dpp.extAction(
    //  denops,
    //  context,
    //  options,
    //  "local",
    //  "local",
    //  {
    //    directory: "~/work",
    //    options: {
    //      frozen: true,
    //      merged: false,
    //    },
    //  },
    //) as Plugin[] | undefined;

    //if (localPlugins) {
    //  // Merge localPlugins
    //  for (const plugin of localPlugins) {
    //    if (plugin.name in recordPlugins) {
    //      recordPlugins[plugin.name] = Object.assign(
    //        recordPlugins[plugin.name],
    //        plugin,
    //      );
    //    } else {
    //      recordPlugins[plugin.name] = plugin;
    //    }
    //  }
    //}

    //const lazyResult = await dpp.extAction(
    //  denops,
    //  context,
    //  options,
    //  "lazy",
    //  "makeState",
    //  {
    //    plugins: Object.values(recordPlugins),
    //  },
    //) as LazyMakeStateResult | undefined;

    const plugins: Plugin[] = [
      {
        name: "denops.vim",
      },
    ];
    const stateLines: string[] = [];

    return {
      ftplugins,
      hooksFiles,
      plugins,
      stateLines,
    };
  }
}
