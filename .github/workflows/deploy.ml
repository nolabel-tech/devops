name: Deploy Docker Compose to Remote Server

on:
  push:
    branches:
      - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up SSH
        uses: webfactory/ssh-agent@v0.5.4
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Copy Docker Compose file to server
        run: scp docker-compose.yml ${{ secrets.SSH_USER }}@${{ secrets.SERVER_IP }}:/path/to/deployment

      - name: Deploy using Docker Compose
        run: |
          ssh ${{ secrets.SSH_USER }}@${{ secrets.SERVER_IP }} << EOF
            cd /path/to/deployment
            docker-compose down
            docker-compose pull
            docker-compose up -d
          EOF

      - name: Cleanup (optional)
        run: |
          ssh ${{ secrets.SSH_USER }}@${{ secrets.SERVER_IP }} << EOF
            docker system prune -af
          EOF
