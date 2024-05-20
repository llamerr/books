import { type Config } from "drizzle-kit";

import { env } from "~/env";

export default {
  schema: [
    './src/server/db/schema.ts',
    './src/server/db/next-auth.ts',
    './src/server/db/BooksSchema.tables.ts',
    './src/server/db/BooksSchema.relations.ts',
    './src/server/db/GuestbookSchema.ts',
  ],
  dialect: "postgresql",
  dbCredentials: {
    url: env.DATABASE_URL,
  },
  tablesFilter: ["library-ledger_*"],
} satisfies Config;
