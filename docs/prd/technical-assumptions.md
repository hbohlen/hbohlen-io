# Technical Assumptions

* **Repository Structure:** **Monorepo**
* **Service Architecture:** **Declarative Configuration**
* **Testing Requirements:** The primary method of testing for the MVP will be **Build & Deploy Validation**. Post-MVP, the strategy will evolve to include **Full System VM-Based Testing** for automation.
* **Additional Assumptions:**
    * The entire system will be managed using the Nix ecosystem: **NixOS**, **Flakes**, **Disko**, and **Home Manager**.
    * The configuration repository will be hosted on **GitHub**.
    * Secrets will be managed using **`sops-nix`** or a similar dedicated tool.
