<template>
  <div>
    <h1>Ini halaman saya</h1>
    <p>Angka: {{ number }}</p>
    <button @click="increment">Tambah 1</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      number: 0,
    };
  },
  methods: {
    increment() {
      this.number++;
    },
  },
};
</script>

<style>
h1 {
    font-weight: bold;
    color: red;
}
</style>