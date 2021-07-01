local publishPackage() = {
    name: "publish-package",
    kind: "pipeline",
    type: "docker",

    steps: [
        {
            name: "publish-github",
            image: "helpmeplz",
            environment: {github_pat: {from_secret: "github_pat"}},
            commands: [".drone/scripts/publish.sh github"]
        }
    ]
}
