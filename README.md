```bash
make decrypt-sops-api && sed -e 's/: /="/;s/$/"/g' containers/api/.env-f > containers/api/.env
```
