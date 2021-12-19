## Formatting yaml to env format

```bash
sed -e 's/: /="/;s/$/"/g' containers/api/.env-f > containers/api/.env
```
