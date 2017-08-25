import Danger

print("Evaluating Dangerfile")

let danger = Danger()

print("Modified:")
for file in danger.git.modifiedFiles {
    print(" - " + file)
}

warn("Warning: bad stuff")
fail("Failure: bad stuff happened")
markdown("## Markdown for GitHub")
