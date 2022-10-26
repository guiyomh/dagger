package cue

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
	"universe.dagger.io/bash"
)

#Image: {
	repository: string | *"alpine"
	tag:        string | *"3.16"

	// Registry authentication
	auth?: {
		username: string
		secret:   dagger.#Secret
	}

	cueVersion: string | *"v0.4.3"

	docker.#Build & {
		steps: [
			docker.#Pull & {
				source: "\(repository):\(tag)"
				if auth != _|_ {
					"auth": auth
				}
			},
			docker.#Run & {
				command: {
					name: "sh"
					flags: "-c": #"""
					apk add curl bash
					"""#
				}
			},
			bash.#Run & {
				script: contents: """
				echo "Installing cue version \(cueVersion)"
				curl -L "https://github.com/cue-lang/cue/releases/download/\(cueVersion)/cue_\(cueVersion)_linux_amd64.tar.gz" | tar zxf - -C /usr/local/bin
				cue version
				"""
			}
		]
	}
}