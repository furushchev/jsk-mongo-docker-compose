pipeline = Source({name: "mongo", tail: true})
    .transform({ name: "log" })
    .save({name: "elastic"})
