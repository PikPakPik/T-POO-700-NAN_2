<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar -->
    <div :class="`bg-white transition-all duration-300 ease-in-out ${isOpen ? 'w-64' : 'w-20'} flex flex-col`">
      <div class="flex items-center justify-between p-4">
        <h1 v-if="isOpen" class="text-2xl text-gray-800 w-full text-center">Time<span
            class="text-[#FABB18]">Manager</span></h1>
      </div>
      <nav class="flex-1">
        <ul :class="`space-y-2 ${isOpen ? 'p-8' : 'p-2'}`">
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
            <AppNavLink to="/workingTimes/1" label="Historique" :active="route.path === '/workingTimes/6'"
              :isOpen="isOpen">
              <svg width="23" height="23" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path fill-rule="evenodd" clip-rule="evenodd"
                  d="M12.2145 9.21165C12.2345 8.95115 12.4517 8.75 12.713 8.75H12.9642C13.221 8.75 13.4361 8.94465 13.4617 9.20025L14 14.5833L17.8314 16.7727C17.9872 16.8617 18.0833 17.0274 18.0833 17.2068V17.4287C18.0833 17.7584 17.7698 17.9978 17.4518 17.9111L12.0653 16.4421C11.8339 16.379 11.68 16.1605 11.6984 15.9213L12.2145 9.21165Z"
                  :fill="route.path === '/workingTimes/6' ? '#FABB18' : 'black'" />
                <path opacity="0.3" fill-rule="evenodd" clip-rule="evenodd"
                  d="M7.12815 1.52768C6.86405 1.21293 6.3541 1.3334 6.25877 1.73306L4.87779 7.5227C4.80011 7.84835 5.05818 8.15685 5.39243 8.13791L11.3483 7.8004C11.7592 7.77711 11.9676 7.29508 11.703 6.97981L10.207 5.19686C11.2262 4.84858 12.307 4.66667 13.4167 4.66667C18.8936 4.66667 23.3334 9.10651 23.3334 14.5833C23.3334 20.0602 18.8936 24.5 13.4167 24.5C7.93992 24.5 3.50008 20.0602 3.50008 14.5833C3.50008 13.6639 3.62459 12.7634 3.86736 11.8979L1.62074 11.2677C1.32494 12.3223 1.16675 13.4343 1.16675 14.5833C1.16675 21.3488 6.65126 26.8333 13.4167 26.8333C20.1822 26.8333 25.6667 21.3488 25.6667 14.5833C25.6667 7.81785 20.1822 2.33333 13.4167 2.33333C11.715 2.33333 10.0943 2.68033 8.62155 3.30744L7.12815 1.52768Z"
                  :fill="route.path === '/workingTimes/6' ? 'white' : 'black'" />
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
          <li v-if="true === true">
            <AppNavLink to="/teams" label="Mes équipes" :active="route.path.includes('/teams')" :isOpen="isOpen">
              <svg :fill="route.path.includes('/teams') ? '#FABB18' : 'black'" height="23" width="23" version="1.1"
                id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                viewBox="0 0 512 512" xml:space="preserve">
                <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                <g id="SVGRepo_iconCarrier">
                  <g>
                    <g>
                      <path
                        d="M235.082,392.745c-5.771,0-10.449,4.678-10.449,10.449v4.678c0,5.771,4.678,10.449,10.449,10.449 c5.77,0,10.449-4.678,10.449-10.449v-4.678C245.531,397.423,240.853,392.745,235.082,392.745z">
                      </path>
                    </g>
                  </g>
                  <g>
                    <g>
                      <path
                        d="M492.948,313.357l-31.393-25.855c1.58-10.4,2.38-20.968,2.38-31.502c0-10.534-0.8-21.104-2.381-31.504l31.394-25.856 c10.032-8.262,12.595-22.42,6.099-33.66L456.35,91.029c-4.704-8.173-13.479-13.25-22.903-13.25c-3.19,0-6.326,0.573-9.302,1.695 l-38.109,14.274c-16.546-13.286-34.848-23.869-54.55-31.54l-6.683-40.082C322.676,9.306,311.701,0,298.704,0h-85.408 C200.3,0,189.324,9.307,187.2,22.119l-6.684,40.088c-19.703,7.673-38.007,18.255-54.553,31.542L87.898,79.492 c-2.999-1.138-6.14-1.715-9.338-1.715c-9.414,0-18.191,5.074-22.903,13.241l-42.702,73.96 c-6.499,11.244-3.935,25.403,6.097,33.664l31.394,25.855c-1.58,10.4-2.38,20.969-2.38,31.503c0,10.534,0.8,21.103,2.38,31.503 l-31.394,25.856c-10.032,8.262-12.595,22.42-6.099,33.66l42.703,73.963c4.716,8.171,13.492,13.247,22.904,13.247 c3.205,0,6.352-0.581,9.294-1.703l38.107-14.275c16.547,13.287,34.85,23.87,54.551,31.541l6.682,40.075 C189.316,502.692,200.293,512,213.297,512h85.408c12.991,0,23.967-9.304,26.096-22.118l6.683-40.089 c19.705-7.673,38.008-18.255,54.554-31.542l38.07,14.261c2.999,1.137,6.141,1.713,9.336,1.713c9.411,0,18.185-5.074,22.9-13.241 l42.703-73.962C505.543,335.776,502.979,321.619,492.948,313.357z M298.704,491.102H245.53v-49.427 c0-5.771-4.678-10.449-10.449-10.449c-5.771,0-10.449,4.678-10.449,10.449v49.427h-10.922V376.504 c13.606,4.844,28.061,7.375,42.865,7.382c0.003,0,0.066,0,0.07,0c14.852,0,29.325-2.528,42.928-7.376v114.515h0.001 C299.289,491.069,299,491.102,298.704,491.102z M256.642,362.988h-0.057c-58.964-0.029-106.933-48.026-106.932-106.99 c0.001-34.314,16.175-65.814,43.158-85.745v76.229c0,3.671,1.926,7.072,5.073,8.96l53.381,32.027 c3.309,1.984,7.443,1.984,10.752,0l53.381-32.027c3.147-1.889,5.073-5.29,5.073-8.96v-76.229 c26.983,19.931,43.159,51.432,43.157,85.747c0,28.528-11.143,55.382-31.374,75.614 C312.022,351.846,285.169,362.988,256.642,362.988z M480.949,336.57l-42.705,73.965c-1.326,2.296-4.122,3.423-6.769,2.42 l-43.772-16.397c-3.557-1.331-7.555-0.63-10.444,1.834c-16.925,14.428-36.026,25.589-56.79,33.212v-64.779 c9.585-5.551,18.513-12.386,26.56-20.434c24.179-24.18,37.495-56.281,37.495-90.391c0.001-48.242-26.729-91.831-69.76-113.754 c-3.239-1.651-7.103-1.498-10.203,0.401c-3.099,1.9-4.989,5.274-4.989,8.909v89.011l-42.932,25.759l-42.932-25.759v-89.011 c0-3.635-1.89-7.009-4.989-8.909c-3.099-1.899-6.963-2.05-10.203-0.401c-43.03,21.922-69.76,65.51-69.762,113.752 c-0.001,34.743,13.583,67.154,38.247,91.26c7.858,7.68,16.53,14.23,25.809,19.585v65.235 c-21.258-7.63-40.795-18.958-58.071-33.684c-1.922-1.638-4.333-2.497-6.78-2.497c-1.232,0-2.473,0.217-3.663,0.664l-43.83,16.419 c-0.613,0.234-1.255,0.353-1.905,0.353c-1.969,0-3.81-1.071-4.805-2.796l-42.706-73.968c-1.365-2.361-0.822-5.337,1.288-7.076 L68.389,299.8c2.926-2.411,4.318-6.216,3.635-9.944c-2.03-11.12-3.061-22.509-3.061-33.856c0-11.346,1.03-22.736,3.063-33.854 c0.681-3.729-0.709-7.535-3.636-9.944l-36.051-29.691c-2.112-1.74-2.654-4.716-1.287-7.08l42.705-73.966 c1.323-2.294,4.109-3.429,6.769-2.419l43.772,16.396c3.555,1.33,7.554,0.63,10.444-1.833 c17.417-14.847,37.129-26.244,58.589-33.876c3.576-1.272,6.182-4.382,6.805-8.126l7.679-46.059 c0.446-2.694,2.752-4.649,5.482-4.649h85.408c2.73,0,5.036,1.955,5.485,4.656l7.679,46.053c0.624,3.744,3.23,6.856,6.806,8.126 c21.459,7.631,41.17,19.027,58.586,33.874c2.89,2.463,6.888,3.165,10.444,1.833l43.794-16.405c0.631-0.238,1.287-0.358,1.95-0.358 c1.97,0,3.805,1.064,4.798,2.789l42.706,73.967c1.365,2.361,0.822,5.337-1.288,7.076l-36.052,29.692 c-2.926,2.411-4.318,6.215-3.635,9.944c2.03,11.118,3.061,22.509,3.061,33.855c0,11.346-1.03,22.735-3.063,33.853 c-0.681,3.728,0.709,7.535,3.636,9.944l36.051,29.691C481.774,331.227,482.316,334.205,480.949,336.57z">
                      </path>
                    </g>
                  </g>
                </g>
              </svg>
            </AppNavLink>
          </li>
          <li v-if="true === true">
            <AppNavLink to="/users" label="Mes employées" :active="route.path.includes('/users')" :isOpen="isOpen">
              <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="23" height="23" viewBox="0 0 48 48">
                <path :fill="route.path.includes('/users') ? '#FABB18' : 'black'"
                  d="M 14 1 C 14 1 12.864688 6.2338594 12.304688 11.880859 C 10.810688 13.779859 10.135953 15.853281 10.001953 17.363281 L 9.9941406 17.494141 C 9.9941406 24.058141 12.216406 34.018141 13.191406 38.369141 L 2.7636719 44.1875 C 2.0406719 44.5915 1.7825469 45.504516 2.1855469 46.228516 C 2.4495469 46.700516 2.9295938 46.969234 3.4335938 46.990234 L 3.4257812 46.996094 L 3.4765625 46.996094 C 3.4835625 46.996094 3.4900938 46.998047 3.4960938 46.998047 C 3.5030938 46.998047 3.5105781 46.996094 3.5175781 46.996094 L 44.201172 46.996094 C 44.299172 47.016094 44.397094 47.035156 44.496094 47.035156 C 45.012094 47.035156 45.513969 46.769969 45.792969 46.292969 C 46.211969 45.577969 45.971859 44.658234 45.255859 44.240234 L 34.927734 38.197266 C 34.999734 37.842266 35.080922 37.451531 35.169922 37.019531 C 36.157922 32.228531 37.996094 23.309141 37.996094 17.369141 L 37.990234 17.234375 C 37.855234 15.744375 37.180453 13.700172 35.689453 11.826172 C 35.128453 6.2001719 34 1 34 1 L 31.544922 8.5410156 C 29.589922 7.5880156 27.114187 6.96875 23.992188 6.96875 C 20.878187 6.96875 18.409031 7.5917344 16.457031 8.5527344 L 14 1 z M 15.945312 23.966797 L 22.005859 27.015625 L 18.494141 27.724609 C 17.764141 27.871609 17.042359 27.444375 16.818359 26.734375 L 15.945312 23.966797 z M 31.949219 24.023438 L 31.048828 26.880859 C 30.841828 27.536859 30.166141 27.926344 29.494141 27.777344 L 25.986328 27.001953 L 31.949219 24.023438 z M 33.064453 32.287109 C 32.762453 33.838109 32.472422 35.250109 32.232422 36.412109 C 32.075422 37.172109 31.941797 37.822031 31.841797 38.332031 C 31.712797 38.765031 31.48775 39.130453 31.21875 39.314453 L 25.6875 43.332031 C 25.5775 43.416031 25.507391 43.431641 25.400391 43.431641 L 22.699219 43.431641 C 22.640219 43.431641 22.539859 43.415641 22.380859 43.306641 L 16.845703 39.287109 C 16.697703 39.186109 16.558312 39.001063 16.445312 38.789062 C 16.415312 38.641062 16.369969 38.494469 16.292969 38.355469 C 16.280969 38.333469 16.263 38.317875 16.25 38.296875 L 16.142578 37.814453 C 15.863578 36.568453 15.434422 34.648016 14.982422 32.416016 C 18.523422 33.709016 23.247953 35.286094 23.501953 35.371094 L 23.994141 35.535156 L 33.064453 32.287109 z M 24.070312 36.966797 C 22.673313 36.966797 21.535578 37.233469 20.767578 37.480469 C 20.173578 37.670469 19.894969 38.343297 20.167969 38.904297 L 20.169922 38.90625 C 20.392922 39.36225 20.913484 39.591547 21.396484 39.435547 C 22.006484 39.238547 22.911656 39.013672 23.972656 39.013672 C 25.175656 39.013672 26.139625 39.228828 26.765625 39.423828 C 27.247625 39.572828 27.759469 39.345578 27.980469 38.892578 C 28.255469 38.329578 27.970094 37.652797 27.371094 37.466797 C 26.592094 37.224797 25.442312 36.966797 24.070312 36.966797 z">
                </path>
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
          <div class="flex items-center space-x-4">
            <button @click="toggleSidebar" class="p-1 rounded-full hover:bg-gray-200">
              <v-icon icon="mdi-menu" />
            </button>
            <h2 class="text-xl font-semibold text-gray-800">
              {{ headerStore.title }}
            </h2>
          </div>
          <div class="flex items-center space-x-4">
            <v-btn icon class="mr-2 yellow" @click="startIntro">
              <v-icon>mdi-help-circle</v-icon>
            </v-btn>
            <div class="relative">
              <button @click="toggleUserMenu"
                class="flex items-center space-x-2 rounded-full hover:bg-gray-200 transition-all duration-300 ease-in-out index-intro"
                data-title="Espace utilisateur"
                data-intro="Vous pourrez y retrouver votre profil et le bouton de déconnexion">
                <div class="flex flex-col items-end">
                  <span class="text-sm font-medium text-gray-700">Bruce Wayne</span>
                  <!-- il faudra changer le nom pour qu'il soit dynamique avec le token / store-->
                  <span class="text-xs text-gray-500">Équipe de nuit</span>
                  <!-- il faudra changer le titre pour qu'il soit dynamique avec le token / store (ex: admin / équipe de nuit ?)-->
                </div>
                <img src="@/assets/batman-head.png" alt="User Avatar" class="w-10 h-10 rounded-full" />
              </button>
              <transition enter-active-class="transition ease-out duration-100"
                enter-from-class="transform opacity-0 scale-95" enter-to-class="transform opacity-100 scale-100"
                leave-active-class="transition ease-in duration-75" leave-from-class="transform opacity-100 scale-100"
                leave-to-class="transform opacity-0 scale-95">
                <div v-if="isUserMenuOpen"
                  class="absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-10"
                  role="menu" aria-orientation="vertical" aria-labelledby="user-menu">
                  <a href="/users/1" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    role="menuitem">Votre Profil</a>
                  <!-- il faudra changer le lien pour qu'il soit dynamique avec le token / store-->
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    role="menuitem">Paramètres</a>
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">Aide</a>
                  <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                    role="menuitem">Déconnexion</a>
                </div>
              </transition>
            </div>
          </div>
        </div>
      </header>


      <!-- Page content -->
      <main class="flex-1 bg-gray-100">
        <div class="p-4" v-if="alert">
          <v-alert closable border="start" variant="tonal" class="p-4" title="Batman est en ville !"
            icon="custom:BatmanIcon" type="error" />
        </div>
        <div class="p-4" v-if="overtime">
          <v-alert closable border="start" variant="tonal" class="p-4" title="N'oubliez pas de pointer à votre départ."
            type="warning" />
        </div>
        <div class="p-4" v-if="showAlert">
          <v-alert closable border="start" variant="tonal" class="p-4" title="N'oubliez pas de pointer à votre arrivé."
            type="warning" />
        </div>
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import {
  ref,
  computed,
  onMounted,
  onUnmounted
} from 'vue'
import {
  useRoute
} from 'vue-router'
import AppNavLink from '@/src/components/AppNavLink.vue'
import batmanSong from '@/assets/sounds/batman_transition.ogg'
import { useHeaderFacadeStore } from '@/stores/headerFacadeStore'
import introJs from 'intro.js';
import 'intro.js/introjs.css';
import { useChronoStore } from '@/stores/chronoStore'
import { Howl } from 'howler';

const headerStore = useHeaderFacadeStore()
const chronoStore = useChronoStore()
const isOpen = ref(true)
const route = useRoute()
const isUserMenuOpen = ref(false)
const overtime = ref(false);
const chrono = computed(() => chronoStore.timeElapsed);
const isPlaying = computed(() => chronoStore.isPlaying);
const sevenHourInSecond = 25200
const simulatedLoginTime = new Date(new Date().getTime() - (9 * 60000 + 50 * 1000));
const alertThreshold = 10 * 60000;
const showAlert = ref(false)
const currentPage = ref(route.name);

const toggleSidebar = () => {
  isOpen.value = !isOpen.value
}

const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value
}

const closeUserMenu = (e) => {
  if (!e.target.closest('.relative')) {
    isUserMenuOpen.value = false
  }
}

const alert = ref(false)

const randomTime = Math.floor(Math.random() * (30 - 10 + 1) + 10) * 60000;

const playSound = () => {
  const batmanSound = new Howl({
    src: [batmanSong],
    volume: 0.5,
    loop: false,
    onload: () => {
      console.log(`
        _____________________
        \`-._:  .:'   \`:::  .:\           |\\__/|           /::  .:'   \`:::  .:.-'
            \\      :          \\          |:   |          /         :       /    
             \\     ::    .     \`-_______/ ::   \\_______-'   .      ::   . /      
              |  :   :: ::'  :   :: ::'  :   :: ::'      :: ::'  :   :: :|       
              |     ;::         ;::         ;::         ;::         ;::  |       
              |  .:'   \`:::  .:'   \`:::  .:'   \`:::  .:'   \`:::  .:'   \`:|       
              /     :           :           :           :           :    \\       
             /______::_____     ::    .     ::    .     ::   _____._::____\\      
                           \`----._:: ::'  :   :: ::'  _.----'                    
                                  \`--.       ;::  .--'                           
                                      \`-. .:'  .-'                               
                                         \\    / 
                                          \\  /                                   
                                           \\/ 
      `);
      console.log('BATMAN EST EN VILLE !');
    },
    onend: () => {
      console.log('Fin de la lecture de la chanson de Batman');
    }
  });
  batmanSound.play();
};

setTimeout(() => {
  alert.value = true;
  playSound()
}, randomTime);

watch(
  [chrono, isPlaying],
  ([chronoVal, isPlayingVal]) => {

    if (chronoVal >= sevenHourInSecond && isPlayingVal) {
      overtime.value = true;
    } else {
      overtime.value = false;
    }
  },
  { immediate: true }
);

const checkLoginTime = () => {
  const currentTime = new Date();
  const timeElapsed = currentTime - simulatedLoginTime;
  if (chrono.value == 0 && timeElapsed >= alertThreshold) {
    showAlert.value = true;
  } else {
    showAlert.value = false;
  }

};

let timer;

onMounted(() => {
  checkLoginTime();
  timer = setInterval(checkLoginTime, 30000);
  document.addEventListener('click', closeUserMenu)
})

onUnmounted(() => {
  clearInterval(timer);
  document.removeEventListener('click', closeUserMenu)
})

// Use for training application with introJs
const startIntro = () => {
  const elements = document.querySelectorAll(`.${currentPage.value}-intro`);
  introJs().setOptions({
    steps: [...elements].map((element) => ({
      element: element,
      intro: element.getAttribute('data-intro'),
      title: element.getAttribute('data-title'),
    })),
  }).start();
};
// Watch for route changes to update currentPage
watch(route, (newRoute) => {
  currentPage.value = newRoute.name; // Assumes route names are set to match the page identifiers
});
</script>

<style>
.yellow {
  color: #FFC107;
}
</style>