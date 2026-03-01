import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  const disposable = vscode.commands.registerCommand(
    "hoge.helloWorld",
    () => {
      vscode.window.showInformationMessage("Hello World from Hoge!");
    }
  );

  context.subscriptions.push(disposable);
}

export function deactivate() {}
