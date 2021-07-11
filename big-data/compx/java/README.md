# CompX : Computational Thinking and Big Data

## Share Git Keys

```bash
# in local wsl
cd ~/code/adelaidex/
cp ~/.ssh/id_* .

# in devcontainer
cd /workspaces/adelaidex/
mv id_* ~/.ssh/

sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa.pub
```