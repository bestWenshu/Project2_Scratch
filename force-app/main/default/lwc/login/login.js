import { LightningElement, track } from "lwc";
import login from "@salesforce/apex/LoginController.login";
import resetPassword from "@salesforce/apex/LoginController.resetPassword";

export default class Login extends LightningElement {
  @track accountId = "";
  @track password = "";
  @track newPassword = "";
  @track loginMessage = "";
  @track isFirstTime = false;

  handleAccountIdChange(event) {
    this.accountId = event.target.value;
  }

  handlePasswordChange(event) {
    this.password = event.target.value;
  }

  handleNewPasswordChange(event) {
    this.newPassword = event.target.value;
  }

  handleLogin() {
    login({ accountId: this.accountId, password: this.password })
      .then((result) => {
        if (result === "First time login") {
          this.isFirstTime = true;
          this.loginMessage = "Please reset your password.";
        } else if (result === "Login successful") {
          this.loginMessage = result;
          window.location.href =
            "https://power-ability-803-dev-ed.scratch.my.site.com/customPortal";
        } else {
          this.loginMessage = result;
          this.clearPasswordInput();
        }
      })
      .catch((error) => {
        this.loginMessage = "Error: " + error.body.message;
        this.clearPasswordInput();
      });
  }

  handleResetPassword() {
    if (this.newPassword.length < 8) {
      this.loginMessage = "New password must be at least 8 characters long.";
      this.clearPasswordInput();
      return;
    }
    resetPassword({ accountId: this.accountId, newPassword: this.newPassword })
      .then((result) => {
        this.loginMessage = result;
        this.isFirstTime = false;
        this.clearPasswordInput();
      })
      .catch((error) => {
        this.loginMessage = "Error: " + error.body.message;
      });
  }

  get showLogin() {
    return this.isFirstTime == false;
  }

  get showResetPassword() {
    return this.isFirstTime == true;
  }

  clearPasswordInput() {
    this.password = "";
    const passwordInput = this.template.querySelector(
      'lightning-input[type="password"]'
    );
    if (passwordInput) {
      passwordInput.value = "";
    }
  }
}
