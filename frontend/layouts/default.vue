<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar -->
    <div :class="`bg-white transition-all duration-300 ease-in-out ${isOpen ? 'w-64' : 'w-20'} flex flex-col`">
      <div class="flex items-center justify-between p-4">
        <h1 v-if="isOpen" class="text-xl font-bold text-gray-800">TimeManager</h1>
        <button @click="toggleSidebar" class="p-1 rounded-full hover:bg-gray-200">
          <v-icon icon="mdi-chevron-left" v-if="isOpen" end></v-icon>
          <v-icon icon="mdi-chevron-right" end v-else></v-icon>
        </button>
      </div>
      <nav class="flex-1">
        <ul class="space-y-2 p-4">
          <li>
            <AppNavLink to="/" label="Tableau de bord" :active="route.path === '/'" :isOpen="isOpen">
              <svg width="23" height="23" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="11.375" height="6.5" rx="1.5" fill="#FABB18" />
                <rect x="14.625" y="19.5" width="11.375" height="6.5" rx="1.5" fill="#FABB18" />
                <rect y="9.75" width="11.375" height="16.25" rx="1.5" :fill="route.path === '/' ? 'white' : 'black'" />
                <rect x="14.625" width="11.375" height="16.25" rx="1.5"
                  :fill="route.path === '/' ? 'white' : 'black'" />
              </svg>
            </AppNavLink>
          </li>
          <li>
            <AppNavLink to="/analyze" label="Analyse" :active="route.path === '/analyze'" :isOpen="isOpen">
              <svg width="23" height="23" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path opacity="0.3" fill-rule="evenodd" clip-rule="evenodd"
                  d="M1.5603 14.4203C2.72454 18.9435 6.83057 22.2858 11.7172 22.2858C17.5092 22.2858 22.2046 17.5904 22.2046 11.7984C22.2046 6.45038 18.2015 2.03732 13.0282 1.39221V14.4203H1.5603Z"
                  :fill="route.path === '/analyze' ? 'white' : 'black'" />
                <path fill-rule="evenodd" clip-rule="evenodd"
                  d="M10.4062 9.17628H0C0.645165 4.00306 5.05819 0 10.4062 0L10.4062 9.17628Z"
                  :fill="route.path === '/analyze' ? '#FABB18' : 'black'" />
              </svg>

            </AppNavLink>
          </li>
          <li>
            <AppNavLink to="/history" label="Historique" :active="route.path === '/history'" :isOpen="isOpen">
              <svg width="23" height="23" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path fill-rule="evenodd" clip-rule="evenodd"
                  d="M12.2145 9.21165C12.2345 8.95115 12.4517 8.75 12.713 8.75H12.9642C13.221 8.75 13.4361 8.94465 13.4617 9.20025L14 14.5833L17.8314 16.7727C17.9872 16.8617 18.0833 17.0274 18.0833 17.2068V17.4287C18.0833 17.7584 17.7698 17.9978 17.4518 17.9111L12.0653 16.4421C11.8339 16.379 11.68 16.1605 11.6984 15.9213L12.2145 9.21165Z"
                  :fill="route.path === '/history' ? '#FABB18' : 'black'" />
                <path opacity="0.3" fill-rule="evenodd" clip-rule="evenodd"
                  d="M7.12815 1.52768C6.86405 1.21293 6.3541 1.3334 6.25877 1.73306L4.87779 7.5227C4.80011 7.84835 5.05818 8.15685 5.39243 8.13791L11.3483 7.8004C11.7592 7.77711 11.9676 7.29508 11.703 6.97981L10.207 5.19686C11.2262 4.84858 12.307 4.66667 13.4167 4.66667C18.8936 4.66667 23.3334 9.10651 23.3334 14.5833C23.3334 20.0602 18.8936 24.5 13.4167 24.5C7.93992 24.5 3.50008 20.0602 3.50008 14.5833C3.50008 13.6639 3.62459 12.7634 3.86736 11.8979L1.62074 11.2677C1.32494 12.3223 1.16675 13.4343 1.16675 14.5833C1.16675 21.3488 6.65126 26.8333 13.4167 26.8333C20.1822 26.8333 25.6667 21.3488 25.6667 14.5833C25.6667 7.81785 20.1822 2.33333 13.4167 2.33333C11.715 2.33333 10.0943 2.68033 8.62155 3.30744L7.12815 1.52768Z"
                  :fill="route.path === '/history' ? 'white' : 'black'" />
              </svg>

            </AppNavLink>
          </li>
          <li>
            <AppNavLink to="/settings" label="Paramètres" :active="route.path === '/settings'" :isOpen="isOpen">
              <svg width="23" height="23" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path fill-rule="evenodd" clip-rule="evenodd"
                  d="M0 11.3021L3.78319 7.5189V3.31031H7.99178L11.3021 0L14.6124 3.31031H19.7668V8.46467L22.6042 11.3021L19.7668 14.1395V19.2939H14.6124L11.3021 22.6042L7.99179 19.2939H3.78319V15.0853L0 11.3021ZM15.2 11.3021C15.2 13.1937 13.6666 14.7271 11.775 14.7271C9.88338 14.7271 8.34993 13.1937 8.34993 11.3021C8.34993 9.41049 9.88338 7.87704 11.775 7.87704C13.6666 7.87704 15.2 9.41049 15.2 11.3021Z"
                  :fill="route.path === '/settings' ? '#FABB18' : 'black'" />
              </svg>
            </AppNavLink>
          </li>
        </ul>
      </nav>
    </div>

    <!-- Main content -->
    <div class="flex-1 flex flex-col">
      <!-- Header -->
       <header class="bg-white shadow-sm">
        <div class="flex items-center justify-between px-4 py-3">
          <button @click="toggleSidebar" class="p-1 rounded-full hover:bg-gray-200">
            <v-icon icon="mdi-menu" />
          </button>
          <h2 class="text-xl font-semibold text-gray-800">
            {{ headerTitle }}
          </h2>
          <div class="flex items-center space-x-4">
            <div class="relative">
              <button 
                @click="toggleUserMenu" 
                class="flex items-center space-x-2 rounded-full hover:bg-gray-200 transition-all duration-300 ease-in-out"
              >
                <div class="flex flex-col items-end">
                  <span class="text-sm font-medium text-gray-700">John Doe</span>
                  <span class="text-xs text-gray-500">Développeur</span>
                </div>
                <div class="w-10 h-10 rounded-full bg-yellow-400 flex items-center justify-center">
                  <v-icon icon="mdi-account" class="text-gray-800" />
                </div>
              </button>
              <transition
                enter-active-class="transition ease-out duration-100"
                enter-from-class="transform opacity-0 scale-95"
                enter-to-class="transform opacity-100 scale-100"
                leave-active-class="transition ease-in duration-75"
                leave-from-class="transform opacity-100 scale-100"
                leave-to-class="transform opacity-0 scale-95"
              >
                <div 
                  v-if="isUserMenuOpen" 
                  class="absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none"
                  role="menu"
                  aria-orientation="vertical"
                  aria-labelledby="user-menu"
                >
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Votre Profil</a>
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Paramètres</a>
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Aide</a>
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Déconnexion</a>
                </div>
              </transition>
            </div>
          </div>
        </div>
      </header>


      <!-- Page content -->
      <main class="flex-1 p-6 bg-gray-100">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
  import { ref, computed } from 'vue'
  import { useRoute } from 'vue-router'
  import AppNavLink from '@/src/components/AppNavLink.vue' // Adjust the path as necessary

  const isOpen = ref(true)
const route = useRoute()
  const isUserMenuOpen = ref(false)

  const toggleSidebar = () => {
    isOpen.value = !isOpen.value
  }

  const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value
}

  const headerTitle = computed(() => {
    switch (route.path) {
      case '/':
        return 'Tableau de bord';
      case '/analyze':
        return 'Analyse';
      case '/history':
        return 'Historique';
      case '/settings':
        return 'Paramètres';
      default:
        return 'Bienvenue';
    }
  })

  const closeUserMenu = (e) => {
  if (!e.target.closest('.relative')) {
    isUserMenuOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', closeUserMenu)
})

onUnmounted(() => {
  document.removeEventListener('click', closeUserMenu)
})
</script>