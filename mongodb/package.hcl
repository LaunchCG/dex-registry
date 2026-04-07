meta {
  name        = "mongodb"
  version     = "1.0.0"
  description = "MongoDB and Mongoose ODM expertise for Node.js"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "typescript" {
  version = ">=1.0.0"
}

# MongoDB/Mongoose skill
skill "mongodb" {
  description = "Expert in MongoDB and Mongoose ODM for Node.js"
  content     = file("skills/mongodb.md")
}
