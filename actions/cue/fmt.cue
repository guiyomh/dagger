package cue

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

#Fmt: {
	// Source of the project
	source: dagger.#FS

	// Docker image
	image: #Image

	container: docker.#Run & {
		input: *image.output | _
		entrypoint: []
		workdir: "/src"
		command: {
			name: "sh"
			flags: "-c": #"""
				find . -name '*.cue' -not -path '*/cue.mod/*' -print | time xargs -t -n 1 -P 8 cue fmt -s
				"""#
		}
		mounts: contents: {
			dest:     "/src"
			contents: source
		}
	}

}
