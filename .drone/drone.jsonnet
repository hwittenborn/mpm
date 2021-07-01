local publishPackage() = {
    name: "publish-package",
    kind: "pipeline",
    type: "docker",

    steps: [
        {
            name: "publish-github",
            image: "proget.hunterwittenborn.com/docker/hunter/makedeb:beta",
            environment: {github_pat: {from_secret: "github_pat"}},
            commands: [".drone/scripts/publish.sh github"]
        }
    ]
};

[
    publishPackage(),
]
