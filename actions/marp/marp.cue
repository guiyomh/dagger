package marp

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

#Html: {

	source: dagger.#FS

	// Path to markdown slides
	markdown: string

	// Docker image to execute
	image: #Image

	// Path of the marp script's output directory
	// May be absolute, or relative to the workdir
	outputDir: string | *"/build"

	// Output directory
	output: container.export.directories."/output"

	container: docker.#Run & {
		input: *image.output | _
		entrypoint: []
		command: {
			name: "sh"
			flags: "-c": """
                set -x
                MARP_USER="$(id -u):$(id -g)"
                docker-entrypoint \\
                    --html \\
                    --output /src/\(outputDir)/index.html \\
                    /src/\(markdown)
                if [ -d /src/\(outputDir) ]; then
                    mv /src/\(outputDir) /output
                else
                    mkdir /output
                fi
                """
		}
		mounts: {
			"contents": {
				dest:     "/src"
				contents: source
				ro:       false
			}
		}

		export: {
			directories: "/output": dagger.#FS
		}
	}
}
