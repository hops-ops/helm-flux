# helm-flux

Installs the Flux2 Helm chart with a minimal, stable interface.

## Quick Start

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: Flux
metadata:
  name: flux
spec:
  clusterName: my-cluster
```

## Development

```bash
make render
make validate
make test
```
