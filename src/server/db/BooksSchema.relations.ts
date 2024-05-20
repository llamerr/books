import { relations } from 'drizzle-orm';

import { authors, authorsDetails, authorsNames, authorsToWorks, works, worksToWorks } from './BooksSchema.tables';

// one-to-many authors --< authorsNames
export const authorsToNamesR = relations(authors, ({ many }) => ({
  authorNames: many(authorsNames, { relationName: 'authorNames' }),
}));
// many-to-one authorsNames >-- authors
export const namesToAuthorsR = relations(authorsNames, ({ one }) => ({
  author: one(authors, {
    fields: [authorsNames.authorId],
    references: [authors.id],
    relationName: 'authorNames',
  }),
}));

// one-to-many authors --< authorsDetails
export const authorsToDetailsR = relations(authors, ({ many }) => ({
  authorDetails: many(authorsDetails, { relationName: 'authorDetails' }),
}));
// many-to-one authorsDetails >-- authors
export const detailsToAuthorsR = relations(authorsDetails, ({ one }) => ({
  author: one(authors, {
    fields: [authorsDetails.authorId],
    references: [authors.id],
    relationName: 'authorDetails',
  }),
}));

// many-to-many authors >-< works
export const authorsToWorksR = relations(authors, ({ many }) => ({
  works: many(authorsToWorks, { relationName: 'works' }),
}));
// many-to-many works >-< authors
export const worksToAuthorsR = relations(works, ({ many }) => ({
  authors: many(authorsToWorks, { relationName: 'authors' }),
}));
// many-to-many authors >-< works
export const authorsToWorksRR = relations(authorsToWorks, ({ one }) => ({
  author: one(authors, {
    fields: [authorsToWorks.authorId],
    references: [authors.id],
    relationName: 'authors',
  }),
  work: one(works, {
    fields: [authorsToWorks.workId],
    references: [works.id],
    relationName: 'works',
  }),
}));

// many-to-many works >-< works
export const worksToWorksR = relations(works, ({ many }) => ({
  parentWorks: many(worksToWorks, { relationName: 'parentWorks' }),
  childWorks: many(worksToWorks, { relationName: 'childWorks' }),
}));
// many-to-many works >-< works
export const worksToWorksRR = relations(worksToWorks, ({ one }) => ({
  parentWork: one(works, {
    fields: [worksToWorks.parentWorkId],
    references: [works.id],
    relationName: 'parentWorks',
  }),
  childWork: one(works, {
    fields: [worksToWorks.childWorkId],
    references: [works.id],
    relationName: 'childWorks',
  }),
}));
