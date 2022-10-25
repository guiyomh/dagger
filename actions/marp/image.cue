package marp

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

#Image: {
	repository: string | *"marpteam/marp-cli"
	tag:        string | *"v2.2.0"
	// Registry authentication
	auth?: {
		username: string
		secret:   dagger.#Secret
	}

	docker.#Pull & {
		source: "\(repository):\(tag)"
		if auth != _|_ {
			"auth": auth
		}
	}
}
