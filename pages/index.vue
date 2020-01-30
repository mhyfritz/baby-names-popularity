<template>
  <v-container class="fill-height" fluid>
    <v-row justify="center">
      <div id="gender-select">
        <label
          :class="
            selected.gender === 'female' ? 'primary--text' : 'accent--text'
          "
        >
          <input
            @change="init"
            type="radio"
            value="female"
            v-model="selected.gender"
          />
          <i class="fa fa-venus" />
        </label>
        <label
          :class="selected.gender === 'male' ? 'primary--text' : 'accent--text'"
        >
          <input
            @change="init"
            type="radio"
            value="male"
            v-model="selected.gender"
          />
          <i class="fa fa-mars" />
        </label>
      </div>
    </v-row>
    <v-row justify="center">
      <v-select
        @change="init"
        :items="years"
        label="Year"
        v-model="selected.year"
        outlined
        class="my-4"
        style="max-width: 600px;"
      ></v-select>
    </v-row>
    <v-row>
      <v-col cols="12" lg="6">
        <v-btn @click="toggleChartTheme" text>
          <i
            class="fa"
            :class="chartTheme === 'dark' ? 'fa-sun-o' : 'fa-moon-o'"
          />
        </v-btn>
        <div ref="chart"></div>
      </v-col>
      <v-col cols="12" lg="6">
        <v-row align="end" dense>
          <v-col class="flex-grow-0">
            <v-btn
              @click="selected.rows = []"
              :disabled="selected.rows.length === 0"
              small
              outlined
              >Unselect all</v-btn
            >
          </v-col>
          <v-col>
            <v-text-field
              v-model="search"
              append-icon="fa-search"
              label="Search"
              single-line
              hide-details
            />
          </v-col>
        </v-row>

        <v-data-table
          class="table"
          dense
          show-select
          :search="search"
          :page.sync="page"
          :footer-props="{
            'items-per-page-options': [10, 25, 50, 100, -1]
          }"
          v-model="selected.rows"
          :headers="tableHeaders"
          :items="subsetByYear"
          item-key="name"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import names from 'baby-names-cologne'

export default {
  data() {
    return {
      selected: {
        gender: 'female',
        year: '',
        name: '',
        rows: []
      },
      names,
      years: [],
      rankExtent: [],
      search: '',
      page: 1,
      tableHeaders: [
        { text: 'Name', value: 'name' },
        { text: 'Rank', value: 'rank' },
        { text: 'Count', value: 'count' }
      ],
      chartTheme: 'dark'
    }
  },
  computed: {
    subsetByYear() {
      return this.names
        .filter(
          n =>
            n.gender === this.selected.gender && n.year === this.selected.year
        )
        .sort((a, b) => a.rank - b.rank)
    }
  },
  methods: {
    init() {
      this.selected.rows = [this.subsetByYear[0], this.subsetByYear[1]]
      this.page = 1
    },
    toggleChartTheme() {
      this.chartTheme = this.chartTheme === 'dark' ? 'light' : 'dark'
      this.renderChart()
    },
    renderChart() {
      const data = this.selected.rows.map(row => ({
        name: row.name,
        x: this.years,
        y: this.years.map(year => {
          const record = this.names.find(
            n =>
              n.name === row.name &&
              n.year === year &&
              n.gender === this.selected.gender
          )
          return record ? record.rank : null
        }),
        type: 'scatter'
      }))

      const layout = {
        title: 'Popularity over the years',
        showlegend: true, // show legend for single name as well
        xaxis: {
          title: 'Year',
          zeroline: false,
          range: [this.years[0] - 1, this.years[this.years.length - 1] + 1],
          gridcolor: '#ccc'
        },
        yaxis: {
          title: 'Rank',
          range: [this.rankExtent[1], 0],
          gridcolor: '#ccc',
          zerolinecolor: '#ccc'
        }
      }

      if (this.chartTheme === 'dark') {
        layout.xaxis.gridcolor = layout.yaxis.gridcolor = layout.yaxis.zerolinecolor =
          '#555'
        layout.plot_bgcolor = layout.paper_bgcolor = '#121212'
        layout.font = { color: '#fff' }
      }

      const config = { displaylogo: false }

      Plotly.newPlot(this.$refs.chart, data, layout, config)
    }
  },
  mounted() {
    this.years = [...new Set(this.names.map(n => n.year))].sort()
    this.rankExtent = [
      Math.min(...this.names.map(n => n.rank)),
      Math.max(...this.names.map(n => n.rank))
    ]
    this.selected.year = this.years[this.years.length - 1]
    this.init()
  },
  watch: {
    'selected.rows': 'renderChart'
  }
}
</script>

<style scoped>
#gender-select {
  font-size: 3rem;
}
#gender-select input {
  width: 0;
  height: 0;
}
#gender-select label {
  cursor: pointer;
}
</style>
