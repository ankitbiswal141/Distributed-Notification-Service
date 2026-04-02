package notifier

import (
	"context"
	"log"
	"sync"
	"time"
)

type Task struct {
	ID        string
	Recipient string
	Message   string
}

type Engine struct {
	WorkerCount int
	TaskQueue   chan Task
	wg          sync.WaitGroup
}

func NewEngine(workers int, buffer int) *Engine {
	return &Engine{
		WorkerCount: workers,
		TaskQueue:   make(chan Task, buffer),
	}
}

func (e *Engine) Start(ctx context.Context) {
	for i := 1; i <= e.WorkerCount; i++ {
		e.wg.Add(1)
		go e.worker(i, ctx)
	}
}

func (e *Engine) worker(id int, ctx context.Context) {
	defer e.wg.Done()
	log.Printf("[Worker %d] Started", id)
	for {
		select {
		case task := <-e.TaskQueue:
			log.Printf("[Worker %d] Processing notification for: %s", id, task.Recipient)
			time.Sleep(100 * time.Millisecond) // Simulate I/O
		case <-ctx.Done():
			log.Printf("[Worker %d] Shutting down", id)
			return
		}
	}
}