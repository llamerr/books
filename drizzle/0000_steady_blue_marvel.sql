CREATE TABLE IF NOT EXISTS "library-ledger_post" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(256),
	"createdById" varchar(255) NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_account" (
	"userId" varchar(255) NOT NULL,
	"type" varchar(255) NOT NULL,
	"provider" varchar(255) NOT NULL,
	"providerAccountId" varchar(255) NOT NULL,
	"refresh_token" text,
	"access_token" text,
	"expires_at" integer,
	"token_type" varchar(255),
	"scope" varchar(255),
	"id_token" text,
	"session_state" varchar(255),
	CONSTRAINT "library-ledger_account_provider_providerAccountId_pk" PRIMARY KEY("provider","providerAccountId")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_session" (
	"sessionToken" varchar(255) PRIMARY KEY NOT NULL,
	"userId" varchar(255) NOT NULL,
	"expires" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_user" (
	"id" varchar(255) PRIMARY KEY NOT NULL,
	"name" varchar(255),
	"email" varchar(255) NOT NULL,
	"emailVerified" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
	"image" varchar(255)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_verificationToken" (
	"identifier" varchar(255) NOT NULL,
	"token" varchar(255) NOT NULL,
	"expires" timestamp with time zone NOT NULL,
	CONSTRAINT "library-ledger_verificationToken_identifier_token_pk" PRIMARY KEY("identifier","token")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_authors" (
	"id" serial PRIMARY KEY NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_authors_details" (
	"id" serial PRIMARY KEY NOT NULL,
	"author_id" integer NOT NULL,
	"language" text NOT NULL,
	"description" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_authors_names" (
	"id" serial PRIMARY KEY NOT NULL,
	"author_id" integer NOT NULL,
	"language" text NOT NULL,
	"name" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_authors_to_works" (
	"author_id" integer NOT NULL,
	"work_id" integer NOT NULL,
	CONSTRAINT "library-ledger_authors_to_works_author_id_work_id_pk" PRIMARY KEY("author_id","work_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_editions" (
	"id" serial PRIMARY KEY NOT NULL,
	"work_id" integer NOT NULL,
	"isbn" text NOT NULL,
	"language" text NOT NULL,
	"title" text NOT NULL,
	"description" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_editions_to_authors" (
	"id" serial PRIMARY KEY NOT NULL,
	"edition_id" integer NOT NULL,
	"author_id" integer NOT NULL,
	"role" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_works" (
	"id" serial PRIMARY KEY NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "library-ledger_works_to_works" (
	"parent_work_id" integer NOT NULL,
	"child_work_id" integer NOT NULL,
	CONSTRAINT "library-ledger_works_to_works_parent_work_id_child_work_id_pk" PRIMARY KEY("parent_work_id","child_work_id")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_post" ADD CONSTRAINT "library-ledger_post_createdById_library-ledger_user_id_fk" FOREIGN KEY ("createdById") REFERENCES "public"."library-ledger_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_account" ADD CONSTRAINT "library-ledger_account_userId_library-ledger_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."library-ledger_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_session" ADD CONSTRAINT "library-ledger_session_userId_library-ledger_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."library-ledger_user"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_authors_details" ADD CONSTRAINT "library-ledger_authors_details_author_id_library-ledger_authors_id_fk" FOREIGN KEY ("author_id") REFERENCES "public"."library-ledger_authors"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_authors_names" ADD CONSTRAINT "library-ledger_authors_names_author_id_library-ledger_authors_id_fk" FOREIGN KEY ("author_id") REFERENCES "public"."library-ledger_authors"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_authors_to_works" ADD CONSTRAINT "library-ledger_authors_to_works_author_id_library-ledger_authors_id_fk" FOREIGN KEY ("author_id") REFERENCES "public"."library-ledger_authors"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_authors_to_works" ADD CONSTRAINT "library-ledger_authors_to_works_work_id_library-ledger_works_id_fk" FOREIGN KEY ("work_id") REFERENCES "public"."library-ledger_works"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_editions" ADD CONSTRAINT "library-ledger_editions_work_id_library-ledger_works_id_fk" FOREIGN KEY ("work_id") REFERENCES "public"."library-ledger_works"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_editions_to_authors" ADD CONSTRAINT "library-ledger_editions_to_authors_edition_id_library-ledger_editions_id_fk" FOREIGN KEY ("edition_id") REFERENCES "public"."library-ledger_editions"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_editions_to_authors" ADD CONSTRAINT "library-ledger_editions_to_authors_author_id_library-ledger_authors_id_fk" FOREIGN KEY ("author_id") REFERENCES "public"."library-ledger_authors"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_works_to_works" ADD CONSTRAINT "library-ledger_works_to_works_parent_work_id_library-ledger_works_id_fk" FOREIGN KEY ("parent_work_id") REFERENCES "public"."library-ledger_works"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "library-ledger_works_to_works" ADD CONSTRAINT "library-ledger_works_to_works_child_work_id_library-ledger_works_id_fk" FOREIGN KEY ("child_work_id") REFERENCES "public"."library-ledger_works"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "createdById_idx" ON "library-ledger_post" ("createdById");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "name_idx" ON "library-ledger_post" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "account_userId_idx" ON "library-ledger_account" ("userId");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "session_userId_idx" ON "library-ledger_session" ("userId");