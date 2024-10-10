<template>
    <ChartManager type="pie" :datas="data" />
    <ChartManager type="bar" :datas="data" />
    <ChartManager type="line" :datas="data" />
    <ChartManager type="radar" :datas="data" />
</template>

<script lang="ts">
import ChartManager from '@/src/components/chartManager.vue'

export default {
    name: 'ChartManagerPage',
    components: { ChartManager },
    data() {
        return {
            data: {
                labels: ['a', 'b', 'c'],
                datasets: [
                    {
                        label: 'data',
                        data: [1]
                    },
                    {
                        label: 'data2',
                        data: [1, 2, 3]
                    },
                    {
                        label: 'data3',
                        data: [39]
                    },
                    {
                        label: 'data4',
                        data: [1,5,10]
                    },
                    {
                        label: 'data5',
                        data: [1, 2, 3]
                    },
                ]
            }
        }
    }
}
</script>