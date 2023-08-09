Changes for 1.10.0 since 1.9.2
------------------------------

  - ipaserver: Do not enable random serial numbers by default (#1073)
  - ipagroup: Fix ensuring external group group members (without trust-ad) (#1072)
  - Ansible lint fixes (#1069)
  - ipareplica/server: Enable removal from domain with undeployment (#1068)
  - ipaclient: Defer krb5 configuration fix (#1067)
  - ipareplica role: Remove usage of undefined parameters. (#1062)
  - roles/ipaserver: Allow deployments with random serial numbers (#1060)
  - ipahost: Make return value depending on hosts parameter (#1058)
  - ipauser: Make return value depending on users parameter (#1053)
  - Migrated to SPDX license. (#1051)
  - ipaclient: Defer creating the final krb5.conf on clients (#1050)
  - Update `EXAMPLE` sections for multiuser and multihost handling. (#1047)
  - Fix ansible-lint on tests (#1046)
  - ipauser: Better description of UID and GID parameters (#1045)
  - ipaclient: Fix allow_repair with removed krb5.conf and DNS lookup (#1037)
  - [RFE] Allow multiple groups creation (#1001)
  - Add subid option to select the sssd profile with-subid. (#974)

Detailed changelog for 1.10.0 since 1.9.2 by author
---------------------------------------------------
  3 authors, 26 commits

Denis Karpelevich (3)

  - [RFE] Allow multiple groups creation.
  - Add subid option to select the sssd profile with-subid.
  - Update `EXAMPLE` sections for multiuser and multihost handling.

Rafael Guterres Jeffman (8)

  - roles/ipaserver: Allow deployments with random serial numbers
  - ipareplica role: Remove usage of undefined parameters.
  - Migrated to SPDX license.
  - ipauser: Better description of UID and GID parameters
  - ansible-lint: License must be defined as a list.
  - ansible-lint: Fixed dangling 'when' clause.
  - ansible-lint: Fix key order on upstream tests
  - ansible-lint: Use 'missing-import' instead of '505'

Thomas Woerner (15)

  - ipaserver: Do not enable random serial numbers by default
  - ipagroup: Handle ensuring groups with mixed types without IPA fix 6741
  - ipagroup: Fix ensuring external group group members (without trust-ad)
  - ipareplica/server: Enable removal from domain with undeployment
  - tests/config/test_config_sid: Mark tasks as noqa 503
  - ipareplica/server: Always cleanup root IPA cache
  - ipaclient_configure_dns_resolver: Removed bad aliases
  - ipapwpolicy: The alias for usercheck in argument_spec had typo
  - ipanetgroup: Missing type for action and state DOCUMENTATION section
  - ipaclient: ipaclient_fix_ca also needs krb_name parameter
  - ipaclient: ipaclient_setup_nss also needs krb_name parameter
  - ipahost: Make return value depending on hosts parameter
  - ipauser: Make return value depending on users parameter
  - ipaclient: Defer creating the final krb5.conf on clients
  - ipaclient: Fix allow_repair with removed krb5.conf and DNS lookup

