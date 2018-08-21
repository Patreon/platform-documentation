# Patreon Platform Documentation 
This is the public resource that powers [docs.patreon.com](https://docs.patreon.com). If you would like to contribute, just make a pull request! 

## Operations

### Deploying updated model documentation

Documentation for platform models visible on [docs.patreon.com](https://docs.patreon.com/#apiv2-resources) can be updated with the following steps.
1. Update and commit the relevant file in `patreon_py` at `app/api/resources/platform_<your model class>/schema.py` with appropriate `.description` values suitable to be displayed to external developers.
2. Pull that branch on your local devx and run `devx attach`
3. `cd /opt/code/patreon_py`
4. `python3 ./scripts/platform_documentation/generate_docs.py`
5. In your terminal window, or tmux session, copy the relevant sections of the generated markdown output (everything following `Checking Webhook`) into `platform-documentation/source/includes/_resources_v2.md`.

## Powered by slate

The Patreon API docs use [slate](https://github.com/lord/slate) and more documentation on the docs system can be found there.
