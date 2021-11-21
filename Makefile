default:
	flatpak-builder --force-clean build-dir de.manu311.Hon.yml
repo:
	flatpak-builder --repo=repo --force-clean build-dir de.manu311.Hon.yml
