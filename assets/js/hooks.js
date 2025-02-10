let Hooks = {};

Hooks.AutoHideFlash = {
  mounted() {
    console.log("Flash message appeared!", this.el);

    if (this.el) {
      setTimeout(() => {
        this.el.style.transition = "opacity 0.5s";
        this.el.style.opacity = "0";

        setTimeout(() => this.el.remove(), 500);
      }, 3000);
    }
  }
};

export default Hooks;
