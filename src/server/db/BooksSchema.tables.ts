import type { InferSelectModel } from 'drizzle-orm';
import { integer, primaryKey, serial, text } from 'drizzle-orm/pg-core';
import { createInsertSchema } from 'drizzle-zod';
import { createTable } from './createTable';

// just author unique id
export const authors = createTable('authors', {
  id: serial('id').primaryKey(),
});
export type SelectAuthors = InferSelectModel<typeof authors> & {
  authorNames?: Array<SelectAuthorsNames>;
  authorDetails?: Array<SelectAuthorsDetails>;
  works?: Array<SelectWorks>;
};
export const insertAuthorsSchema = createInsertSchema(authors);

// one-to-many authors --< authorsNames
// author name aliases, each author can have multiple name variations, even in same language
export const authorsNames = createTable('authors_names', {
  id: serial('id').primaryKey(),
  authorId: integer('author_id')
    .notNull()
    .references(() => authors.id),
  language: text('language').notNull(),
  name: text('name').notNull(),
});
export type SelectAuthorsNames = InferSelectModel<typeof authorsNames> & {
  author?: SelectAuthors;
};
export const insertAuthorsNamesSchema = createInsertSchema(authorsNames);

// one-to-many authors --< authorsDetails
// each author can have multiple descriptions in different languages
// each language can have only one description of the same author
export const authorsDetails = createTable('authors_details', {
  id: serial('id').primaryKey(),
  authorId: integer('author_id')
    .notNull()
    .references(() => authors.id),
  language: text('language').notNull(),
  description: text('description').notNull(),
});
export type SelectAuthorsDetails = InferSelectModel<typeof authorsDetails> & {
  author?: SelectAuthors;
};
export const insertAuthorsDetailsSchema = createInsertSchema(authorsDetails);

// work is an abstract version of edition that convey an idea
//   edition on the other hand can have different variations in words because of different editions or translations of original work, yet they still convey the same idea
// purpose of the work is to track your reading progress if you only care about ideas/meaning and not on details of some particular work
//   yet you can track separate works if you want, in case they are in different languages or made by different translators, etc
//   having single work as a source of abstract idea may help building recommendations, which are built based on ideas and not details of implementation
export const works = createTable('works', {
  id: serial('id').primaryKey(),
});
export type SelectWorks = InferSelectModel<typeof works> & {
  authors?: Array<SelectAuthors>;
  parentWorks?: Array<SelectWorks>;
  childWorks?: Array<SelectWorks>;
};

// many-to-many authors >-< works
// each work can have multiple authors
// having work authors is mandatory
export const authorsToWorks = createTable(
  'authors_to_works',
  {
    authorId: integer('author_id')
      .notNull()
      .references(() => authors.id),
    workId: integer('work_id')
      .notNull()
      .references(() => works.id),
  },
  (t) => ({
    pk: primaryKey({ columns: [t.authorId, t.workId] }),
  }),
);

// many-to-many works >-< works
export const worksToWorks = createTable(
  'works_to_works',
  {
    parentWorkId: integer('parent_work_id')
      .notNull()
      .references(() => works.id),
    childWorkId: integer('child_work_id')
      .notNull()
      .references(() => works.id),
  },
  (t) => ({
    pk: primaryKey({ columns: [t.parentWorkId, t.childWorkId] }),
  }),
);

// each edition represents a work
// each work can have multiple editions
// each edition can have multiple works
// each language can have multiple descriptions of the same edition because of different editions, isbn or translation variants
export const editions = createTable('editions', {
  id: serial('id').primaryKey(),
  workId: integer('work_id')
    .notNull()
    .references(() => works.id),
  isbn: text('isbn').notNull(),
  language: text('language').notNull(),
  title: text('title').notNull(),
  description: text('description').notNull(),
});

// and each edition also can have additional multiple authors, but in case of edition they may be translators/editors/etc
// having edition authors is optional
export const editionsToAuthors = createTable('editions_to_authors', {
  id: serial('id').primaryKey(),
  editionId: integer('edition_id')
    .notNull()
    .references(() => editions.id),
  authorId: integer('author_id')
    .notNull()
    .references(() => authors.id),
  role: text('role').notNull(),
});
