
CREATE TABLE IF NOT EXISTS bookshelf (
userid text NOT NULL,
bookid text NOT NULL,
book text NOT NULL,
PRIMARY KEY(userid, bookid)
);




CREATE TABLE IF NOT EXISTS recommend (
bookid text PRIMARY KEY NOT NULL,
book text NOT NULL
);




CREATE TABLE IF NOT EXISTS rank (
bookid text PRIMARY KEY NOT NULL,
book text NOT NULL
);



CREATE TABLE IF NOT EXISTS history (
bookid text PRIMARY KEY NOT NULL,
book text NOT NULL
);


