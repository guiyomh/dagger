package marp

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

#Build: {
	source: dagger.#FS

	// Path to markdown slides
	markdown: string

	// Name of the build
	name:        string | *"index"
	_build_name: name

	// Docker image to execute
	image: #Image

	// Path of the marp script's output directory
	// May be absolute, or relative to the workdir
	outputDir: string | *"/build"

	// Path to additional theme CSS files
	theme?: string

	// Command line
	_do: string

	outputType: *"html" | "pdf" | "pptx"

	// Output directory
	output: container.export.directories."/output"

	*{
		theme: ""
		_do:   "docker-entrypoint --\(outputType) --allow-local-files"
	} | {
		theme: string
		_do:   "docker-entrypoint --\(outputType) --allow-local-files --theme-set /src/\(theme)"
	}

	container: docker.#Run & {
		input: *image.output | _
		entrypoint: []
		command: {
			name: "sh"
			flags: "-c": """
                set -x
                MARP_USER="$(id -u):$(id -g)"
                \(_do) --output /src/\(outputDir)/\(_build_name).\(outputType) /src/\(markdown)
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
