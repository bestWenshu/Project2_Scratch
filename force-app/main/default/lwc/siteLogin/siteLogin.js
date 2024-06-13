import { LightningElement, track } from "lwc";
import loginAsUser from "@salesforce/apex/SiteLoginController.loginAsUser";

export default class SiteLogin extends LightningElement {
  @track userEmail = "";
  @track userPassword = "";
  @track loginMessage = "";
  @track passwordVisible = false;

  handleEmailChange(event) {
    this.userEmail = event.target.value;
  }

  handlePasswordChange(event) {
    this.userPassword = event.target.value;
  }

  togglePasswordVisibility() {
    this.passwordVisible = !this.passwordVisible;
  }

  handleLogin() {
    loginAsUser({ email: this.userEmail, password: this.userPassword })
      .then((result) => {
        if (result) {
          window.location.href =
            "https://eere3-dev-ed.develop.my.site.com/customPortal";
          this.loginMessage = "Login successful!";
        } else {
          this.loginMessage =
            "Failure: loginPage is null, check credentials and user status.";
        }
      })
      .catch((error) => {
        this.loginMessage = "Failure: " + error.body.message;
      });
  }
  get computedPasswordType() {
    return this.passwordVisible ? "text" : "password";
  }
}
