#!/usr/bin/env bash

# Enable strict mode: exit immediately if any command fails,
# if any unset variable is used, or if any command in a pipeline fails
set -eu
set -o pipefail

# Source external library script
# for utility functions
source "${BASH_SOURCE[0]%/*}"/lib.sh

# --------------------------------------------------------
# Users declarations

# Declare an associative array for user passwords
declare -A users_passwords
users_passwords=(
	[logstash_internal]="${LOGSTASH_INTERNAL_PASSWORD:-}"
	[kibana_system]="${KIBANA_SYSTEM_PASSWORD:-}"
	[metricbeat_internal]="${METRICBEAT_INTERNAL_PASSWORD:-}"
	[filebeat_internal]="${FILEBEAT_INTERNAL_PASSWORD:-}"
	[heartbeat_internal]="${HEARTBEAT_INTERNAL_PASSWORD:-}"
	[monitoring_internal]="${MONITORING_INTERNAL_PASSWORD:-}"
	[beats_system]="${BEATS_SYSTEM_PASSWORD:-}"
)

# Declare an associative array for user roles
declare -A users_roles
users_roles=(
	[logstash_internal]='logstash_writer'
	[metricbeat_internal]='metricbeat_writer'
	[filebeat_internal]='filebeat_writer'
	[heartbeat_internal]='heartbeat_writer'
	[monitoring_internal]='remote_monitoring_collector'
)

# --------------------------------------------------------
# Roles declarations

# Declare an associative array for role configuration files
declare -A roles_files
roles_files=(
	[logstash_writer]='logstash_writer.json'
	[metricbeat_writer]='metricbeat_writer.json'
	[filebeat_writer]='filebeat_writer.json'
	[heartbeat_writer]='heartbeat_writer.json'
)

# --------------------------------------------------------

# Log message indicating the script is waiting for Elasticsearch to be available
log 'Waiting for availability of Elasticsearch. This can take several minutes.'

# Initialize exit code variable
declare -i exit_code=0

# Wait for Elasticsearch to be available, capturing the exit code if it fails
wait_for_elasticsearch || exit_code=$?

# Handle various exit codes and log appropriate error messages
if ((exit_code)); then
	case $exit_code in
		6)
			suberr 'Could not resolve host. Is Elasticsearch running?'
			;;
		7)
			suberr 'Failed to connect to host. Is Elasticsearch healthy?'
			;;
		28)
			suberr 'Timeout connecting to host. Is Elasticsearch healthy?'
			;;
		*)
			suberr "Connection to Elasticsearch failed. Exit code: ${exit_code}"
			;;
	esac

	exit $exit_code
fi

# Log message indicating Elasticsearch is running
sublog 'Elasticsearch is running'

# Log message indicating the script is waiting for built-in users to be initialized
log 'Waiting for initialization of built-in users'

# Wait for built-in users to be initialized, capturing the exit code if it fails
wait_for_builtin_users || exit_code=$?

# Log error and exit if built-in users initialization times out
if ((exit_code)); then
	suberr 'Timed out waiting for condition'
	exit $exit_code
fi

# Log message indicating built-in users were initialized
sublog 'Built-in users were initialized'

# Loop through each role defined in the roles_files array
for role in "${!roles_files[@]}"; do
	log "Role '$role'"

	# Determine the path to the role configuration file
	declare body_file
	body_file="${BASH_SOURCE[0]%/*}/roles/${roles_files[$role]:-}"
	
	# Skip if the role configuration file does not exist
	if [[ ! -f "${body_file:-}" ]]; then
		sublog "No role body found at '${body_file}', skipping"
		continue
	fi

	# Log message indicating the role is being created or updated
	sublog 'Creating/updating'
	
	# Ensure the role is created or updated with the specified configuration
	ensure_role "$role" "$(<"${body_file}")"
done

# Loop through each user defined in the users_passwords array
for user in "${!users_passwords[@]}"; do
	log "User '$user'"
	
	# Skip if no password is defined for the user
	if [[ -z "${users_passwords[$user]:-}" ]]; then
		sublog 'No password defined, skipping'
		continue
	fi

	# Check if the user already exists
	declare -i user_exists=0
	user_exists="$(check_user_exists "$user")"

	# If the user exists, set the password
	if ((user_exists)); then
		sublog 'User exists, setting password'
		set_user_password "$user" "${users_passwords[$user]}"
	else
		# Skip if no role is defined for the user
		if [[ -z "${users_roles[$user]:-}" ]]; then
			suberr '  No role defined, skipping creation'
			continue
		fi

		# Create the user with the specified password and role
		sublog 'User does not exist, creating'
		create_user "$user" "${users_passwords[$user]}" "${users_roles[$user]}"
	fi
done
