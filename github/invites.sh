gh_accept_invites() {
  invites_json=$(gh api /user/repository_invitations 2>/dev/null)
  invite_count=$(echo "$invites_json" | jq 'length')

  if [ "$invite_count" -eq 0 ]; then
    echo "No pending GitHub invitations."
    return 0
  fi

  echo "You have $invite_count pending GitHub invitations."
  echo

  # List invitations in a readable format
  echo "$invites_json" | jq -r '.[] | "Repo: \(.repository.full_name) | ID: \(.id)"'
  echo

  printf "Accept all invitations? Type 'yes' to confirm: "
  read answer

  if [ "$answer" != "yes" ]; then
    echo "Cancelled."
    return 1
  fi

  # Accept each invitation and speak the repo name, not the ID
  echo "$invites_json" | jq -r '.[] | "\(.id) \(.repository.full_name)"' |
  while read -r id repo; do
    echo "Accepting invitation to $repo..."
    gh api --method PATCH /user/repository_invitations/$id >/dev/null
  done

  echo "All invitations accepted."
}

