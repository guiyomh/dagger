package markdown

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
)

#Image: {
    repository: string | *"tmknom/markdownlint"
	tag:        string | *"0.31.1"
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