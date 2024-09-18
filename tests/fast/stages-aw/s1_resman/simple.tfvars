automation = {
  federated_identity_pool      = null
  federated_identity_providers = null
  project_id                   = "fast-prod-automation"
  project_number               = 123456
  outputs_bucket               = "test"
  service_accounts = {
    resman-r = "ldj-prod-resman-0r@fast2-prod-iac-core-0.iam.gserviceaccount.com"
  }
}
billing_account = {
  id = "000000-111111-222222"
}
custom_roles = {
  # organization_iam_admin = "organizations/123456789012/roles/organizationIamAdmin",
  gcve_network_admin            = "organizations/123456789012/roles/gcveNetworkAdmin"
  organization_admin_viewer     = "organizations/123456789012/roles/organizationAdminViewer"
  service_project_network_admin = "organizations/123456789012/roles/xpnServiceAdmin"
  storage_viewer                = "organizations/123456789012/roles/storageViewer"
}
groups = {
  gcp-billing-admins      = "gcp-billing-admins",
  gcp-devops              = "gcp-devops",
  gcp-vpc-network-admins  = "gcp-vpc-network-admins",
  gcp-organization-admins = "gcp-organization-admins",
  gcp-security-admins     = "gcp-security-admins",
  gcp-support             = "gcp-support"
}
organization = {
  domain      = "fast.example.com"
  id          = 123456789012
  customer_id = "C00000000"
}
prefix = "fast2"
folder_iam = {
  data_platform = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  gcve = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  gke = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  sandbox = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  security = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  network = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  teams = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
  tenants = {
    "roles/owner"   = ["user:extra-owner@fast.example.com"]
    "roles/browser" = ["user:extra-browser@fast.example.com"]
  }
}