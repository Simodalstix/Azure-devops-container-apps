# Contributing

## Development Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Make** your changes
4. **Test** locally:
   ```bash
   # Validate Terraform
   cd infra/envs/dev
   terraform fmt -check -recursive
   terraform validate
   terraform init -backend=false
   terraform plan
   
   # Test application (if modified)
   cd src && npm test
   ```
5. **Commit** with clear messages
6. **Push** and create a Pull Request

## Code Standards

- **Terraform**: Follow [HashiCorp style guide](https://developer.hashicorp.com/terraform/language/style)
- **Node.js**: Use ESLint configuration in package.json
- **Documentation**: Update README.md for significant changes

## Pull Request Requirements

- [ ] All CI checks pass
- [ ] Terraform plan shows expected changes
- [ ] Documentation updated if needed
- [ ] No secrets or credentials in code

## Infrastructure Changes

- Test in `dev` environment first
- Include Terraform plan output in PR description
- Consider impact on existing resources
- Update variable examples if needed

## Questions?

Open an issue for discussion before major changes.