# Networking Architecture for Azure Container Apps

## Built-in Load Balancing vs External Options

### Azure Container Apps Built-in Load Balancing (Current Implementation)

**What we're using:**

- Azure Container Apps has **built-in load balancing** at the platform level
- No separate Load Balancer or Application Gateway needed for basic scenarios
- Automatic traffic distribution across replicas
- Built-in SSL termination and custom domains

**Architecture:**

```
Internet → Container Apps Environment (Built-in LB) → Container App Replicas
```

**Pros:**

- Simplified architecture
- Lower cost
- Automatic scaling integration
- Built-in health checks
- No additional management overhead

**Cons:**

- Limited advanced routing features
- No WAF (Web Application Firewall) capabilities
- Less control over load balancing algorithms

### When to Add Application Gateway

**Use Application Gateway when you need:**

- **Web Application Firewall (WAF)** protection
- **Advanced routing** (path-based, host-based)
- **SSL offloading** with custom certificates
- **Multiple backend pools** (Container Apps + other services)
- **Advanced monitoring** and analytics
- **Custom health probes**

**Architecture with Application Gateway:**

```
Internet → Application Gateway (WAF) → Container Apps Environment → Container App Replicas
```

### When to Add Load Balancer

**Use Azure Load Balancer when you need:**

- **Layer 4 (TCP/UDP)** load balancing
- **Internal load balancing** within VNet
- **High availability** across availability zones
- **Non-HTTP protocols**

**Note:** Standard Load Balancer is typically used for internal scenarios or non-HTTP traffic.

## Current Implementation Decision

**For this project, we're using the built-in Container Apps load balancing because:**

1. **Simplicity**: Single API service with HTTP/HTTPS traffic
2. **Cost-effectiveness**: No additional Azure resources needed
3. **Auto-scaling integration**: Built-in load balancer scales with replicas
4. **Sufficient for most use cases**: Handles SSL, health checks, and traffic distribution

## When to Upgrade Architecture

### Add Application Gateway if you need:

- WAF protection against OWASP Top 10
- Multiple applications behind single endpoint
- Advanced SSL certificate management
- Custom routing rules
- DDoS protection

### Add Load Balancer if you need:

- Internal load balancing within VNet
- Non-HTTP protocols (TCP, UDP)
- Cross-region load balancing
- Integration with on-premises networks

## Implementation Options

### Option 1: Current (Built-in Load Balancing)

```hcl
# No additional resources needed
# Container Apps handles load balancing automatically
resource "azurerm_container_app" "api" {
  # ... existing configuration
  ingress {
    external_enabled = true  # Built-in load balancing
    target_port      = 3000
  }
}
```

### Option 2: With Application Gateway

```hcl
resource "azurerm_application_gateway" "main" {
  name                = "ag-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  # Backend pool pointing to Container Apps
  backend_address_pool {
    name  = "container-apps-pool"
    fqdns = [azurerm_container_app.api.latest_revision_fqdn]
  }
}
```

### Option 3: With Load Balancer (Internal)

```hcl
resource "azurerm_lb" "internal" {
  name                = "lb-internal-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
```

## Recommendation for This Project

**Stick with built-in load balancing** for the initial implementation because:

- Single containerized API service
- Standard HTTP/HTTPS traffic
- Cost-effective solution
- Simplified architecture
- Easy to upgrade later if needed

**Consider upgrading to Application Gateway when:**

- You need WAF protection
- Multiple services need to be exposed
- Advanced routing requirements emerge
- Compliance requires additional security layers

## Migration Path

If you need to add Application Gateway later:

1. Deploy Application Gateway in the same resource group
2. Configure backend pool pointing to Container Apps FQDN
3. Update DNS to point to Application Gateway
4. Test traffic flow
5. Update monitoring to include Application Gateway metrics

The current architecture is production-ready and can be enhanced as requirements evolve.
