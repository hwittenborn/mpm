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
        },

        {
            name: "publish-dur",
            image: "proget.hunterwittenborn.com/docker/hunter/makedeb:beta",
            environment: {
                ssh_key: {from_secret: "ssh_key"},
                known_hosts: {from_secret: "known_hosts"}
            },
            commands: [".drone/scripts/publish.sh dur"]
        }
    ]
};

[
    publishPackage(),
]
