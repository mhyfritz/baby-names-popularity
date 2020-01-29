<template>
  <v-app dark>
    <v-app-bar fixed app>
      <v-toolbar-title>
        Baby names
      </v-toolbar-title>
      <v-spacer />
      <a href="https://github.com/mhyfritz/baby-names-app" target="_blank">
        <i class="fa fa-github-alt" />
      </a>
    </v-app-bar>
    <v-content>
      <v-container>
        <nuxt />
      </v-container>
    </v-content>
    <v-footer fixed app>
      <span>&copy; {{ new Date().getFullYear() }} M. H.-Y. Fritz</span>
    </v-footer>
  </v-app>
</template>
