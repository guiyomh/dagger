package markdown

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
)

#Lint: {
    // source code
    source: dagger.#FS

    // Files to lint
    files: [...string]

	image: #Image

    docker.#Run & {
        input: *image.output | _
        mounts: "source": {
            dest:     "/src"
            contents: source
        }
        workdir: "/src"
        command: {
            name: "markdownlint"
            args: files
        }
    }
}