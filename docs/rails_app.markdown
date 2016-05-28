# Configuring Opsworks for a Rails Application

This repository contains all the cookbooks necessary to deploy a Rails
application to AWS Opsworks with minimal work.

Add the following recipes to the respective lifecycle events:

* **Setup**: `stembolt_opsworks::dependencies`, `stembolt_opsworks::ruby`
* **Configure**:
* **Deploy**: `stembolt_opsworks::deploy`
* **Undeploy**:
* **Shutdown**:
