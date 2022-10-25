package npm

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
)

#Image: {
    repository: string | *"node"
	tag:        string | *"19"
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