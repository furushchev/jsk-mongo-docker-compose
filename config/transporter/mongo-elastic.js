pipeline = Source({name: "mongo", tail: true})
    .transform({ filename: "debug-logging.js" })
    .save({name: "elastic"})
