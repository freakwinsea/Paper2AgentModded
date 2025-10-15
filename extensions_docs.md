\# Gemini CLI Extensions

\_This documentation is up-to-date with the v0.4.0 release.\_

Gemini CLI extensions package prompts, MCP servers, and custom commands into a  
familiar and user-friendly format. With extensions, you can expand the  
capabilities of Gemini CLI and share those capabilities with others. They are  
designed to be easily installable and shareable.

To see examples of extensions, you can browse a gallery of  
\[Gemini CLI extensions\](https://geminicli.com/extensions/browse/).

See \[getting started docs\](/docs/extensions/getting-started-extensions) for a guide on  
creating your first extension.

See \[releasing docs\](/docs/extensions/extension-releasing) for an advanced guide on setting up  
GitHub releases.

\#\# Extension management

We offer a suite of extension management tools using \`gemini extensions\`  
commands.

Note that these commands are not supported from within the CLI, although you can  
list installed extensions using the \`/extensions list\` subcommand.

Note that all of these commands will only be reflected in active CLI sessions on  
restart.

\#\#\# Installing an extension

You can install an extension using \`gemini extensions install\` with either a  
GitHub URL or a local path.

Note that we create a copy of the installed extension, so you will need to run  
\`gemini extensions update\` to pull in changes from both locally-defined  
extensions and those on GitHub.

NOTE: If you are installing an extension from GitHub, you'll need to have \`git\`  
installed on your machine. See  
\[git installation instructions\](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)  
for help.

\`\`\`  
gemini extensions install https://github.com/gemini-cli-extensions/security  
\`\`\`

This will install the Gemini CLI Security extension, which offers support for a  
\`/security:analyze\` command.

\#\#\# Uninstalling an extension

To uninstall, run \`gemini extensions uninstall extension-name\`, so, in the case  
of the install example:

\`\`\`  
gemini extensions uninstall gemini-cli-security  
\`\`\`

\#\#\# Disabling an extension

Extensions are, by default, enabled across all workspaces. You can disable an  
extension entirely or for specific workspace.

For example, \`gemini extensions disable extension-name\` will disable the  
extension at the user level, so it will be disabled everywhere.  
\`gemini extensions disable extension-name \--scope=workspace\` will only disable  
the extension in the current workspace.

\#\#\# Enabling an extension

You can enable extensions using \`gemini extensions enable extension-name\`. You  
can also enable an extension for a specific workspace using  
\`gemini extensions enable extension-name \--scope=workspace\` from within that  
workspace.

This is useful if you have an extension disabled at the top-level and only  
enabled in specific places.

\#\#\# Updating an extension

For extensions installed from a local path or a git repository, you can  
explicitly update to the latest version (as reflected in the  
\`gemini-extension.json\` \`version\` field) with  
\`gemini extensions update extension-name\`.

You can update all extensions with:

\`\`\`  
gemini extensions update \--all  
\`\`\`

\#\# Extension creation

We offer commands to make extension development easier.

\#\#\# Create a boilerplate extension

We offer several example extensions \`context\`, \`custom-commands\`,  
\`exclude-tools\` and \`mcp-server\`. You can view these examples  
\[here\](https://github.com/google-gemini/gemini-cli/tree/main/packages/cli/src/commands/extensions/examples).

To copy one of these examples into a development directory using the type of  
your choosing, run:

\`\`\`  
gemini extensions new path/to/directory custom-commands  
\`\`\`

\#\#\# Link a local extension

The \`gemini extensions link\` command will create a symbolic link from the  
extension installation directory to the development path.

This is useful so you don't have to run \`gemini extensions update\` every time  
you make changes you'd like to test.

\`\`\`  
gemini extensions link path/to/directory  
\`\`\`

\#\# How it works

On startup, Gemini CLI looks for extensions in \`\<home\>/.gemini/extensions\`

Extensions exist as a directory that contains a \`gemini-extension.json\` file.  
For example:

\`\<home\>/.gemini/extensions/my-extension/gemini-extension.json\`

\#\#\# \`gemini-extension.json\`

The \`gemini-extension.json\` file contains the configuration for the extension.  
The file has the following structure:

\`\`\`json  
{  
  "name": "my-extension",  
  "version": "1.0.0",  
  "mcpServers": {  
    "my-server": {  
      "command": "node my-server.js"  
    }  
  },  
  "contextFileName": "GEMINI.md",  
  "excludeTools": \["run\_shell\_command"\]  
}  
\`\`\`

\- \`name\`: The name of the extension. This is used to uniquely identify the  
  extension and for conflict resolution when extension commands have the same  
  name as user or project commands. The name should be lowercase or numbers and  
  use dashes instead of underscores or spaces. This is how users will refer to  
  your extension in the CLI. Note that we expect this name to match the  
  extension directory name.  
\- \`version\`: The version of the extension.  
\- \`mcpServers\`: A map of MCP servers to configure. The key is the name of the  
  server, and the value is the server configuration. These servers will be  
  loaded on startup just like MCP servers configured in a  
  \[\`settings.json\` file\](/docs/get-started/configuration). If both an extension  
  and a \`settings.json\` file configure an MCP server with the same name, the  
  server defined in the \`settings.json\` file takes precedence.  
  \- Note that all MCP server configuration options are supported except for  
    \`trust\`.  
\- \`contextFileName\`: The name of the file that contains the context for the  
  extension. This will be used to load the context from the extension directory.  
  If this property is not used but a \`GEMINI.md\` file is present in your  
  extension directory, then that file will be loaded.  
\- \`excludeTools\`: An array of tool names to exclude from the model. You can also  
  specify command-specific restrictions for tools that support it, like the  
  \`run\_shell\_command\` tool. For example,  
  \`"excludeTools": \["run\_shell\_command(rm \-rf)"\]\` will block the \`rm \-rf\`  
  command. Note that this differs from the MCP server \`excludeTools\`  
  functionality, which can be listed in the MCP server config.

When Gemini CLI starts, it loads all the extensions and merges their  
configurations. If there are any conflicts, the workspace configuration takes  
precedence.

\#\#\# Custom commands

Extensions can provide \[custom commands\](/docs/cli/custom-commands) by placing  
TOML files in a \`commands/\` subdirectory within the extension directory. These  
commands follow the same format as user and project custom commands and use  
standard naming conventions.

\*\*Example\*\*

An extension named \`gcp\` with the following structure:

\`\`\`  
.gemini/extensions/gcp/  
├── gemini-extension.json  
└── commands/  
    ├── deploy.toml  
    └── gcs/  
        └── sync.toml  
\`\`\`

Would provide these commands:

\- \`/deploy\` \- Shows as \`\[gcp\] Custom command from deploy.toml\` in help  
\- \`/gcs:sync\` \- Shows as \`\[gcp\] Custom command from sync.toml\` in help

\#\#\# Conflict resolution

Extension commands have the lowest precedence. When a conflict occurs with user  
or project commands:

1\. \*\*No conflict\*\*: Extension command uses its natural name (e.g., \`/deploy\`)  
2\. \*\*With conflict\*\*: Extension command is renamed with the extension prefix  
   (e.g., \`/gcp.deploy\`)

For example, if both a user and the \`gcp\` extension define a \`deploy\` command:

\- \`/deploy\` \- Executes the user's deploy command  
\- \`/gcp.deploy\` \- Executes the extension's deploy command (marked with \`\[gcp\]\`  
  tag)

\#\# Variables

Gemini CLI extensions allow variable substitution in \`gemini-extension.json\`.  
This can be useful if e.g., you need the current directory to run an MCP server  
using \`"cwd": "${extensionPath}${/}run.ts"\`.

\*\*Supported variables:\*\*

| variable                   | description                                                                                                                                                     |  
| \-------------------------- | \--------------------------------------------------------------------------------------------------------------------------------------------------------------- |  
| \`${extensionPath}\`         | The fully-qualified path of the extension in the user's filesystem e.g., '/Users/username/.gemini/extensions/example-extension'. This will not unwrap symlinks. |  
| \`${workspacePath}\`         | The fully-qualified path of the current workspace.                                                                                                              |  
| \`${/} or ${pathSeparator}\` | The path separator (differs per OS).                                                                                                                            |  
\# Getting Started with Gemini CLI Extensions

This guide will walk you through creating your first Gemini CLI extension.  
You'll learn how to set up a new extension, add a custom tool via an MCP server,  
create a custom command, and provide context to the model with a \`GEMINI.md\`  
file.

\#\# Prerequisites

Before you start, make sure you have the Gemini CLI installed and a basic  
understanding of Node.js and TypeScript.

\#\# Step 1: Create a New Extension

The easiest way to start is by using one of the built-in templates. We'll use  
the \`mcp-server\` example as our foundation.

Run the following command to create a new directory called \`my-first-extension\`  
with the template files:

\`\`\`bash  
gemini extensions new my-first-extension mcp-server  
\`\`\`

This will create a new directory with the following structure:

\`\`\`  
my-first-extension/  
├── example.ts  
├── gemini-extension.json  
├── package.json  
└── tsconfig.json  
\`\`\`

\#\# Step 2: Understand the Extension Files

Let's look at the key files in your new extension.

\#\#\# \`gemini-extension.json\`

This is the manifest file for your extension. It tells Gemini CLI how to load  
and use your extension.

\`\`\`json  
{  
  "name": "my-first-extension",  
  "version": "1.0.0",  
  "mcpServers": {  
    "nodeServer": {  
      "command": "node",  
      "args": \["${extensionPath}${/}dist${/}example.js"\],  
      "cwd": "${extensionPath}"  
    }  
  }  
}  
\`\`\`

\- \`name\`: The unique name for your extension.  
\- \`version\`: The version of your extension.  
\- \`mcpServers\`: This section defines one or more Model Context Protocol (MCP)  
  servers. MCP servers are how you can add new tools for the model to use.  
  \- \`command\`, \`args\`, \`cwd\`: These fields specify how to start your server.  
    Notice the use of the \`${extensionPath}\` variable, which Gemini CLI replaces  
    with the absolute path to your extension's installation directory. This  
    allows your extension to work regardless of where it's installed.

\#\#\# \`example.ts\`

This file contains the source code for your MCP server. It's a simple Node.js  
server that uses the \`@modelcontextprotocol/sdk\`.

\`\`\`typescript  
/\*\*  
 \* @license  
 \* Copyright 2025 Google LLC  
 \* SPDX-License-Identifier: Apache-2.0  
 \*/

import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';  
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';  
import { z } from 'zod';

const server \= new McpServer({  
  name: 'prompt-server',  
  version: '1.0.0',  
});

// Registers a new tool named 'fetch\_posts'  
server.registerTool(  
  'fetch\_posts',  
  {  
    description: 'Fetches a list of posts from a public API.',  
    inputSchema: z.object({}).shape,  
  },  
  async () \=\> {  
    const apiResponse \= await fetch(  
      'https://jsonplaceholder.typicode.com/posts',  
    );  
    const posts \= await apiResponse.json();  
    const response \= { posts: posts.slice(0, 5\) };  
    return {  
      content: \[  
        {  
          type: 'text',  
          text: JSON.stringify(response),  
        },  
      \],  
    };  
  },  
);

// ... (prompt registration omitted for brevity)

const transport \= new StdioServerTransport();  
await server.connect(transport);  
\`\`\`

This server defines a single tool called \`fetch\_posts\` that fetches data from a  
public API.

\#\#\# \`package.json\` and \`tsconfig.json\`

These are standard configuration files for a TypeScript project. The  
\`package.json\` file defines dependencies and a \`build\` script, and  
\`tsconfig.json\` configures the TypeScript compiler.

\#\# Step 3: Build and Link Your Extension

Before you can use the extension, you need to compile the TypeScript code and  
link the extension to your Gemini CLI installation for local development.

1\.  \*\*Install dependencies:\*\*

    \`\`\`bash  
    cd my-first-extension  
    npm install  
    \`\`\`

2\.  \*\*Build the server:\*\*

    \`\`\`bash  
    npm run build  
    \`\`\`

    This will compile \`example.ts\` into \`dist/example.js\`, which is the file  
    referenced in your \`gemini-extension.json\`.

3\.  \*\*Link the extension:\*\*

    The \`link\` command creates a symbolic link from the Gemini CLI extensions  
    directory to your development directory. This means any changes you make  
    will be reflected immediately without needing to reinstall.

    \`\`\`bash  
    gemini extensions link .  
    \`\`\`

Now, restart your Gemini CLI session. The new \`fetch\_posts\` tool will be  
available. You can test it by asking: "fetch posts".

\#\# Step 4: Add a Custom Command

Custom commands provide a way to create shortcuts for complex prompts. Let's add  
a command that searches for a pattern in your code.

1\.  Create a \`commands\` directory and a subdirectory for your command group:

    \`\`\`bash  
    mkdir \-p commands/fs  
    \`\`\`

2\.  Create a file named \`commands/fs/grep-code.toml\`:

    \`\`\`toml  
    prompt \= """  
    Please summarize the findings for the pattern \`{{args}}\`.

    Search Results:  
    \!{grep \-r {{args}} .}  
    """  
    \`\`\`

    This command, \`/fs:grep-code\`, will take an argument, run the \`grep\` shell  
    command with it, and pipe the results into a prompt for summarization.

After saving the file, restart the Gemini CLI. You can now run  
\`/fs:grep-code "some pattern"\` to use your new command.

\#\# Step 5: Add a Custom \`GEMINI.md\`

You can provide persistent context to the model by adding a \`GEMINI.md\` file to  
your extension. This is useful for giving the model instructions on how to  
behave or information about your extension's tools. Note that you may not always  
need this for extensions built to expose commands and prompts.

1\.  Create a file named \`GEMINI.md\` in the root of your extension directory:

    \`\`\`markdown  
    \# My First Extension Instructions

    You are an expert developer assistant. When the user asks you to fetch  
    posts, use the \`fetch\_posts\` tool. Be concise in your responses.  
    \`\`\`

2\.  Update your \`gemini-extension.json\` to tell the CLI to load this file:

    \`\`\`json  
    {  
      "name": "my-first-extension",  
      "version": "1.0.0",  
      "contextFileName": "GEMINI.md",  
      "mcpServers": {  
        "nodeServer": {  
          "command": "node",  
          "args": \["${extensionPath}${/}dist${/}example.js"\],  
          "cwd": "${extensionPath}"  
        }  
      }  
    }  
    \`\`\`

Restart the CLI again. The model will now have the context from your \`GEMINI.md\`  
file in every session where the extension is active.

\#\# Step 6: Releasing Your Extension

Once you are happy with your extension, you can share it with others. The two  
primary ways of releasing extensions are via a Git repository or through GitHub  
Releases. Using a public Git repository is the simplest method.

For detailed instructions on both methods, please refer to the  
\[Extension Releasing Guide\](/docs/extensions/extension-releasing).

\#\# Conclusion

You've successfully created a Gemini CLI extension\! You learned how to:

\- Bootstrap a new extension from a template.  
\- Add custom tools with an MCP server.  
\- Create convenient custom commands.  
\- Provide persistent context to the model.  
\- Link your extension for local development.

From here, you can explore more advanced features and build powerful new  
capabilities into the Gemini CLI.  
\# Extension Releasing

There are two primary ways of releasing extensions to users:

\- \[Git repository\](\#releasing-through-a-git-repository)  
\- \[Github Releases\](\#releasing-through-github-releases)

Git repository releases tend to be the simplest and most flexible approach,  
while GitHub releases can be more efficient on initial install as they are  
shipped as single archives instead of requiring a git clone which downloads each  
file individually. Github releases may also contain platform specific archives  
if you need to ship platform specific binary files.

\#\# Releasing through a git repository

This is the most flexible and simple option. All you need to do is create a  
publicly accessible git repo (such as a public github repository) and then users  
can install your extension using \`gemini extensions install \<your-repo-uri\>\`, or  
for a GitHub repository they can use the simplified  
\`gemini extensions install \<org\>/\<repo\>\` format. They can optionally depend on a  
specific ref (branch/tag/commit) using the \`--ref=\<some-ref\>\` argument, this  
defaults to the default branch.

Whenever commits are pushed to the ref that a user depends on, they will be  
prompted to update the extension. Note that this also allows for easy rollbacks,  
the HEAD commit is always treated as the latest version regardless of the actual  
version in the \`gemini-extension.json\` file.

\#\#\# Managing release channels using a git repository

Users can depend on any ref from your git repo, such as a branch or tag, which  
allows you to manage multiple release channels.

For instance, you can maintain a \`stable\` branch, which users can install this  
way \`gemini extensions install \<your-repo-uri\> \--ref=stable\`. Or, you could make  
this the default by treating your default branch as your stable release branch,  
and doing development in a different branch (for instance called \`dev\`). You can  
maintain as many branches or tags as you like, providing maximum flexibility for  
you and your users.

Note that these \`ref\` arguments can be tags, branches, or even specific commits,  
which allows users to depend on a specific version of your extension. It is up  
to you how you want to manage your tags and branches.

\#\#\# Example releasing flow using a git repo

While there are many options for how you want to manage releases using a git  
flow, we recommend treating your default branch as your "stable" release branch.  
This means that the default behavior for  
\`gemini extensions install \<your-repo-uri\>\` is to be on the stable release  
branch.

Lets say you want to maintain three standard release channels, \`stable\`,  
\`preview\`, and \`dev\`. You would do all your standard development in the \`dev\`  
branch. When you are ready to do a preview release, you merge that branch into  
your \`preview\` branch. When you are ready to promote your preview branch to  
stable, you merge \`preview\` into your stable branch (which might be your default  
branch or a different branch).

You can also cherry pick changes from one branch into another using  
\`git cherry-pick\`, but do note that this will result in your branches having a  
slightly divergent history from each other, unless you force push changes to  
your branches on each release to restore the history to a clean slate (which may  
not be possible for the default branch depending on your repository settings).  
If you plan on doing cherry picks, you may want to avoid having your default  
branch be the stable branch to avoid force-pushing to the default branch which  
should generally be avoided.

\#\# Releasing through Github releases

Gemini CLI extensions can be distributed through  
\[GitHub Releases\](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).  
This provides a faster and more reliable initial installation experience for  
users, as it avoids the need to clone the repository.

Each release includes at least one archive file, which contains the full  
contents of the repo at the tag that it was linked to. Releases may also include  
\[pre-built archives\](\#custom-pre-built-archives) if your extension requires some  
build step or has platform specific binaries attached to it.

When checking for updates, gemini will just look for the "latest" release on  
github (you must mark it as such when creating the release), unless the user  
installed a specific release by passing \`--ref=\<some-release-tag\>\`.

You may also install extensions with the \`--pre-release\` flag in order to get  
the latest release regardless of whether it has been marked as "latest". This  
allows you to test that your release works before actually pushing it to all  
users.

\#\#\# Custom pre-built archives

Custom archives must be attached directly to the github release as assets and  
must be fully self-contained. This means they should include the entire  
extension, see \[archive structure\](\#archive-structure).

If your extension is platform-independent, you can provide a single generic  
asset. In this case, there should be only one asset attached to the release.

Custom archives may also be used if you want to develop your extension within a  
larger repository, you can build an archive which has a different layout from  
the repo itself (for instance it might just be an archive of a subdirectory  
containing the extension).

\#\#\#\# Platform specific archives

To ensure Gemini CLI can automatically find the correct release asset for each  
platform, you must follow this naming convention. The CLI will search for assets  
in the following order:

1\.  \*\*Platform and Architecture-Specific:\*\*  
    \`{platform}.{arch}.{name}.{extension}\`  
2\.  \*\*Platform-Specific:\*\* \`{platform}.{name}.{extension}\`  
3\.  \*\*Generic:\*\* If only one asset is provided, it will be used as a generic  
    fallback.

\- \`{name}\`: The name of your extension.  
\- \`{platform}\`: The operating system. Supported values are:  
  \- \`darwin\` (macOS)  
  \- \`linux\`  
  \- \`win32\` (Windows)  
\- \`{arch}\`: The architecture. Supported values are:  
  \- \`x64\`  
  \- \`arm64\`  
\- \`{extension}\`: The file extension of the archive (e.g., \`.tar.gz\` or \`.zip\`).

\*\*Examples:\*\*

\- \`darwin.arm64.my-tool.tar.gz\` (specific to Apple Silicon Macs)  
\- \`darwin.my-tool.tar.gz\` (for all Macs)  
\- \`linux.x64.my-tool.tar.gz\`  
\- \`win32.my-tool.zip\`

\#\#\#\# Archive structure

Archives must be fully contained extensions and have all the standard  
requirements \- specifically the \`gemini-extension.json\` file must be at the root  
of the archive.

The rest of the layout should look exactly the same as a typical extension, see  
\[extensions.md\](/docs/extensions).

\#\#\#\# Example GitHub Actions workflow

Here is an example of a GitHub Actions workflow that builds and releases a  
Gemini CLI extension for multiple platforms:

\`\`\`yaml  
name: Release Extension

on:  
  push:  
    tags:  
      \- 'v\*'

jobs:  
  release:  
    runs-on: ubuntu-latest  
    steps:  
      \- uses: actions/checkout@v3

      \- name: Set up Node.js  
        uses: actions/setup-node@v3  
        with:  
          node-version: '20'

      \- name: Install dependencies  
        run: npm ci

      \- name: Build extension  
        run: npm run build

      \- name: Create release assets  
        run: |  
          npm run package \-- \--platform=darwin \--arch=arm64  
          npm run package \-- \--platform=linux \--arch=x64  
          npm run package \-- \--platform=win32 \--arch=x64

      \- name: Create GitHub Release  
        uses: softprops/action-gh-release@v1  
        with:  
          files: |  
            release/darwin.arm64.my-tool.tar.gz  
            release/linux.arm64.my-tool.tar.gz  
            release/win32.arm64.my-tool.zip  
\`\`\`

