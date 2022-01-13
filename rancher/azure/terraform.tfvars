f5_password = "DefaultPass12345!"

# Required variables
# - Fill in before beginning quickstart
# ==========================================================

# Azure Subscription ID
azure_subscription_id = ""

# Azure Client ID
azure_client_id = ""

# Azure Client Secret
azure_client_secret = ""

# Azure Tenant ID
azure_tenant_id = ""

# Password used to log in to the `admin` account on the new Rancher server
# - Must be at least 12 characters
rancher_server_admin_password = "DefaultPass12345!"

# Add a windows node to the workload cluster
add_windows_node = false

# Admin password to use for the Windows VM
windows_admin_password = ""

# Optional variables, uncomment to customize the quickstart
# ----------------------------------------------------------

# Azure location for all resources
azure_location = "East US 2"

# Prefix for all resources created by quickstart
prefix = "moleary"

# Azure virtual machine instance size of all created instances
# instance_type = ""

# Docker version installed on target hosts
# - Must be a version supported by the Rancher install scripts
# docker_version = ""

# Kubernetes version used for creating management server cluster
# - Must be supported by RKE terraform provider 1.0.1
# rancher_kubernetes_version = ""

# Kubernetes version used for creating workload cluster
# - Must be supported by RKE terraform provider 1.0.1
workload_kubernetes_version = "v1.20.4-rancher1-1"

# Version of cert-manager to install, used in case of older Rancher versions
# cert_manager_version = ""

# Version of Rancher to install
# rancher_version = ""

