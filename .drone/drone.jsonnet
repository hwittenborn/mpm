local buildAndPublish(a, b) = {
    name: "build-and-publish-" + a,
    kind: "pipeline",
    type: "docker",
    trigger: {branch: [a]},
    steps: [
        {
            name: "build-debian-package",
            image: "proget.hunterwittenborn.com/docker/hunter/makedeb:alpha",
            environment: {release_type: a, package_name: b},
            commands: [".drone/scripts/build.sh"]
        },

        {
            name: "publish-proget",
            image: "proget.hunterwittenborn.com/docker/hunter/makedeb:alpha",
            environment: {proget_api_key: {from_secret: "proget_api_key"}},
            commands: [".drone/scripts/publish.sh"]
        }
    ]
};

[
    buildAndPublish("stable", "mpm"),
    buildAndPublish("alpha", "mpm-alpha"),
]
