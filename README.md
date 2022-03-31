# Shoreline Terraform Cert Op Packs

This [Shoreline Op Pack](#what-are-shoreline-op-packs) contains a collection of modules for SSL/TLS alerting and automatic remediation.

## About Shoreline

The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline [Agents](https://docs.shoreline.io/platform/agents) are efficient and non-intrusive processes running in the background of all your monitored hosts. [Agents](https://docs.shoreline.io/platform/agents) act as the secure link between Shoreline and your environment's [Resources](https://docs.shoreline.io/platform/resources), providing real-time monitoring and metric collection across your fleet. [Agents](https://docs.shoreline.io/platform/agents) can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted [Resources](https://docs.shoreline.io/platform/resources).

Since [Agents](https://docs.shoreline.io/platform/agents) are distributed throughout your fleet and monitor your [Resources](https://docs.shoreline.io/platform/resources) in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using [Alarms](https://docs.shoreline.io/alarms), [Actions](https://docs.shoreline.io/actions), [Bots](https://docs.shoreline.io/bots), and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable [Slack integration](https://docs.shoreline.io/integrations/slack).

Shoreline [Notebooks](https://docs.shoreline.io/ui/notebooks) let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive [Op](https://docs.shoreline.io/op) language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?

Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the [Shoreline Terraform Provider](https://registry.terraform.io/providers/shorelinesoftware/shoreline/latest/docs) and the [Shoreline Platform](https://docs.shoreline.io) to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

## Cert Op Packs

<table role="table" style="vertical-align: middle;">
  <thead>
    <tr style="background-color: #D2D2D2">
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1;">Name</th>
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">AWS</th>
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">Azure</th>
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">GCP</th>
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1;">Details</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1;"><a href="#Certs">Certs</a></td>
      <td style="vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1;"><a href="https://registry.terraform.io/modules/terraform-shoreline-modules/cert-op-pack/shoreline/latest/submodules/certs" target="_blank" rel="noreferrer">Submodule</a>, <a href="https://registry.terraform.io/modules/terraform-shoreline-modules/cert-op-pack/shoreline/latest/examples/certs" target="_blank" rel="noreferrer">Example</a></td>
    </tr>
  </tbody>
</table>

### Certs

The [Cert Op Pack](https://registry.terraform.io/modules/terraform-shoreline-modules/cert-op-pack/shoreline/latest/submodules/certs) monitors SSL/TLS certificates. If the URL has a certificate expiring within the defined limit it triggers a Shoreline Alarm. Additionally, if you enabled and configured the remediation Action, then it renews the certificate using the `certbot` CLI tool.

## Additional resources

Find more detailed documentation on Shoreline and Terraform Op Packs below:

- [Shoreline Documentation](https://docs.shoreline.io/)
- [Op Packs Overview](https://docs.shoreline.io/op/packs)
- [Op Packs Tutorial](https://docs.shoreline.io/op/packs/tutorial)
