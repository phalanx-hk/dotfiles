# typescriptスタイルガイド

## JavaScriptランタイム

ランタイムにはBunを使用します。ユーザーは個人開発や内部ツールなどの開発が主であるため、安定性やセキュリティよりもパフォーマンスを優先しています。

## 基本的なコーディングスタイル

- 再代入しない変数には`const`を使用し、再代入する変数には`let`を使用してください
- `return`文の中で`await`を使わず、Promiseをそのまま返してください
- 制御構文では、1行だけのブロックでも必ず中括弧 `{}` を使用してください
- `Object.assign` よりもスプレッド構文 `{...obj}` を使用してください


## 命名規則
- 型名およびインターフェース名はパスカルケース（例: `UserProfile`）を使用してください
- 変数や関数名はキャメルケース（例: `getUserName`）を使用してください
- 定数には大文字のスネークケース（例: `MAX_RETRY_COUNT`）を使用してください
- isLoading, hasErrorのように補助動詞付きの説明的な名前を使用して、ブール値を表現してください

## importの整理

- importはファイルの先頭にまとめる
- importの順番は以下の通りに整理する
  `組み込みモジュール` → `サードパーティモジュール` → `社内モジュール` → `相対パスモジュール`
- 各importグループの間に空行を入れる
- 各グループ内ではimportをアルファベット順にソートする
- 重複したimportを避ける
- 循環依存を避ける

## 型安全性

- `tsconfig.json`に以下のフラグを有効化してください。
```json
{
  "compilerOptions": {
    "strict": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "exactOptionalPropertyTypes": true,
    "noEmitOnError": true
  }
}
```
- @ts-ignoreや@ts-nocheckなどの型チェックを無視しても良いですが、説明コメントは必ず記載してください


## 型定義

- オブジェクト定義には`type`エイリアスを使用してください。`interface`は使用しないでください。
- `any`は絶対に使わないこと。どうしても使いたくなった場合は、代わりに`unknown`を使用してください
- 関数の引数、戻り値、オブジェクトリテラルは必ず明示的に型を付与してください
- `Enum`は使わないでください。代わりに`Union Type`を使用してください
- 変更しないプロパティや配列には`readonly`を付与してください
- 再利用可能な型にはジェネリクスを使用してください
- TypeScript のユーティリティ型（Partial, Required, Pick, Omit, Record など）を活用する
```ts
type User = {
    id: string;
    name: string;
    age: number;
}
type UserPreview = Pick<User, "id" | "name">; 
type UserUpdate = Partial<Omit<User, "id">>; // id以外のプロパティはオプショナル
type UserMap = Record<string, User>; // keyがstring、valueがUserのオブジェクト
```

- `as const`アサーションを活用して、型を文字列リテラル/数値リテラルに絞り込む
```ts
export const PROVIDERS = ["HF", "Google", "OpenAI"] as const;
export type Provider = (typeof PROVIDERS)[number];
```

## 型検証

- 型検証ライブラリとして`zod`を使用してください

### 型アサーションよりもzodを優先する

- **NEVER** 外部データソース、APIレスポンス、ユーザ入力に対して決して型アサーション(`as Type`)を使わない
- **ALWAYS** 代わりにzodスキーマを定義し、`parse`メソッドで検証を行う
- バリデーション失敗時には適切なエラーハンドリングを実装すること

### zod実装パターン

- Zodのインポートは`import { z } from "zod"`を使用する
- スキーマは関連する型の近く、または専用のスキーマファイルに定義する
- 例外を投げるバリデーションには`schema.parse()`を使用する
- 例外を投げないバリデーションと詳細なエラー取得には`schema.safeParse()`を使用する
- `.refine()`や`.superRefine()`を用いて意味のあるエラーメッセージを付与する
- 必要に応じて`.default()`でデフォルト値を設定する
- `.transform()`を使用して、バリデーションと同時にデータ変換を行う
- バリデーションエラーが発生する可能性を常に考慮し、必ずエラー処理を書く

```ts
// ❌ WRONG: 型アサーションを使用している
type User = {
    id: string;
    email: string;
}

const fetchUser = async (userId: string): Promise<User> => {
    const response = await fetch(`/api/users/${userId}`);
    const data = await response.json();
    return data as User; // 型アサーションは危険
}


// ✅ RIGHT: zodを使用して型検証を行う
import { z } from "zod";

// スキーマ定義
const UserSchema = z.object({
    id: z.string(),
    email: z.string().email(),
});

// スキーマから型を推論
type User = z.infer<typeof UserSchema>;


const fetchUser = async (userId: string): Promise<User> => {
    const response = await fetch(`/api/users/${userId}`);
    const data = await response.json();
    
    // zodで型検証
    return UserSchema.parse(data);
}

// エラーハンドリング例
const fetchUserWithHandling = async (userId: string): Promise<User | null> => {
    try {
        const response = await fetch(`/api/users/${userId}`);
        const data = await response.json();

        const result = UserSchema.safeParse(data);
        if (!result.success) {
            console.error("Validation errors:", result.error.errors);
            return null;
        }

        return result.data;
    } catch (error) {
        console.error("Fetch error:", error);
        return null;
    }
}
```

## エラーハンドリング
- ドメイン固有のエラーにはカスタムエラー型を作成する
- 失敗する可能性のある処理にはResult型を使用する
- Promiseのrejectを適切にハンドリングする

## コードの整理

- 型は専用ファイル(types.ts)や実装と同じファイル内で整理
- 複雑な型はJSDocコメントでドキュメントを記載、簡単な型はコメント不要

