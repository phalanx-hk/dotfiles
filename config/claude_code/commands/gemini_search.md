# Claude コマンド： Gemini Search

このコマンドは、Google Gemini CLIを使用して、Web検索を実行するためのものです。

## 使用方法

```bash
/gemini_search <query>
```

## このコマンドは以下の手順を実行します
1. `gemini` CLIを使用して、指定されたクエリに基づき、以下のコマンドでWeb検索を実行します。
```bash
gemini --prompt "WebSearch: <query>"
```

## 重要な注意事項

- web検索を行う際には、常に `gemini` CLIを使用します。
- 組み込みの`Web_Search`ツールは絶対に使用しないでください。
